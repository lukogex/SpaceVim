---Logger class for logging messages via vim.notify and :messages.
---Usage: `local logger = require("logger").new({ level = "debug", name = "my_name" })`
---`local logger = require("logger"):new({ level = "debug", name = "my_name", log_echo = false })`
---Optionally set the `level` and `name` using the setter functions.
---e.g. `logger:set_level("debug")` or `logger:set_name("my_name")`
---@class Logger
local Logger = {
  -- Set default log level.
  level = vim.g.svim_log_level or vim.log.levels.DEBUG,
  -- Default to not echo messages since vim.notify already does that unless it gets overridden by a notifier plugin.
  log_buffer = true,
  log_buffer_file = true,
  log_file = vim.fn.stdpath("log") .. '/svim.log',
  log_echo = false,
  log_vim = false,
  log_notify = false,
  -- TODO: Check if spacevim notify is still needed or oif we can replace it with `vim.notify`.
  -- I dont see any difference so far, lets remove this part at some point.
  spacevim_notify = false
}

local buffer = require('spacevim.api.vim.buffer')
local notify = require('spacevim.api.notify')

local LOG_BUFFER_NAME = 'svim_logger'

---Function that handles vararg printing, so logs are consistent.
---@vararg any
local function print_args(...)
  local args = { ... }
  if #args == 1 and type(...) == "table" then
    return vim.inspect(...)
  else
    local to_return = ""

    for _, value in ipairs(args) do
      to_return = vim.fn.join({ to_return, vim.inspect(value) }, " ")
    end

    return to_return
  end
end

---Transform the integer log level to its string representation.
---0 : log debug, info, warn, error messages
---1 : log info, warn, error messages
---2 : log warn, error messages
---3 : log error messages
local function print_level(level)
  local level_str = "INFO"
  for l, i in pairs(vim.log.levels) do
    if level == i  then
      level_str = l
    end
  end
  return level_str
end

local function print_line(self, ...)
  local message = print_args(...)
  local _, time = vim.loop.gettimeofday()
  local time_string = string.format('%s:%03d', os.date('%H:%M:%S'), time / 1000)

  return string.format('[%s] [%s] [%s] %s', self.name, time_string, print_level(self.level), message)
end

---@param message string|table<string> log message (either single line or array
---                                of lines to accept vim.inspect() output)
---@param level integer|nil log level defined in vim.log.levels
---@param options LogOptions allows us to set different logging namespaces
local function log_buffer(message, level, self)
  local buffer_id = buffer.create_by_name(LOG_BUFFER_NAME, true, true)

  -- Ensure `message` is always a table to make processing simpler.
  if type(message) == "string" then
    message = {message}
  end

  -- Split `message` on newlines, since nvim_buf_set_lines() does not like them.
  message = vim.tbl_map(function(line)
    return vim.split(line, "\n")
  end, message)
  message = vim.iter(message):flatten(1):totable()

  -- Add the lines to the buffer.
  vim.api.nvim_buf_set_lines(buffer_id, -1, -1, true, message)

  if self.log_buffer_file then
    buffer.write_to_file(buffer_id, self.log_file)
  end
end

-- Use a highlight group based on the level
local function log_echo(message, level, self)
  local hl_group = "Normal"
  if level == vim.log.levels.ERROR then
    hl_group = "ErrorMsg"
  elseif level == vim.log.levels.WARN then
    hl_group = "WarningMsg"
  elseif level == vim.log.levels.INFO then
    hl_group = "None"
  elseif level == vim.log.levels.DEBUG then
    hl_group = "Comment"
  elseif level == vim.log.levels.TRACE then
    hl_group = "Comment"
  end
  vim.api.nvim_echo({ { message, hl_group } }, true, {})
end

-- Send to vim.notify for floating notifications
local function log_notify(message, level, self)
  if self.spacevim_notify then
    notify.notify(message)
  else
    vim.notify(message, level)
  end
end

local function log_print(message, level, self)
  print(print_line(message, level, self))
end

-- TODO: Is this already available for current Neovim version?
-- By default, logs will be written to {name}.log under `stdpath('log')`.
-- The default log level for vim log is `WARN`.
-- local function log_vim(message, level, self)
  -- local vimlog = vim.log.new({ name = 'spacevim', })
  -- vim.log.set_level(log, vim.log.levels.INFO)
--
  -- if level == vim.log.level.ERROR then
    -- vimlog.error(message)
  -- elseif level == vim.log.levels.WARN then
    -- vimlog.warn(message)
  -- elseif level == vim.log.levels.INFO then
    -- vimlog.info(message)
  -- elseif level == vim.log.levels.DEBUG then
    -- vimlog.debug(message)
  -- elseif level == vim.log.levels.TRACE then
    -- vimlog.trace(message)
  -- end
-- end

---Helper function to log to all channels.
---@param message string The message to log
---@param level number The log level (vim.log.levels)
---@param self Logger The logger instance
local function log(message, level, self)
  if self.log_buffer then
    log_buffer(message, level, self)
  end
  if self.log_echo then
    log_echo(message, level, self)
  end
  if self.log_notify then
    log_notify(message, level, self)
  end
  if self.log_print then
    log_print(message, level, self)
  end
  -- if self.log_vim then
    -- log_vim(message, level, self)
  -- end
end

---Constructor for Logger class.
---@param config table Table containing the configuration for the logger.
function Logger:new(config)
  local logger = {}

  logger = vim.tbl_deep_extend("force", self, config)

  local mt = {}
  mt.__index = function(t, k)
    local value = self[k]
    if type(value) == "function" then
      return function(first_arg, ...)
        -- Handle both syntaxes:
        -- 1. logger.debug(...) - first_arg is not the logger
        -- 2. logger:debug(...) - first_arg is the logger
        if first_arg == t then
          -- Called with colon syntax (logger:debug)
          return value(first_arg, ...)
        else
          -- Called with dot syntax (logger.debug)
          return value(t, first_arg, ...)
        end
      end
    else
      return value
    end
  end

  setmetatable(logger, mt)

  return logger
end

function Logger:get_level()
  return self.level
end

---Set the log level for the logger.
---@param level string|number Either a string or number, see `:h vim.log.levels`
function Logger:set_level(level)
  self.level = level
end

function Logger:get_name()
  return self.name
end

---Set the name for the logger.
---The name is logged alongside the log level in each message.
---@param name string
function Logger:set_name(name)
  self.name = name
end

---Set whether to echo messages to :messages buffer
---@param echo boolean
function Logger:set_log_echo(echo)
  self.log_echo = echo
end

---Log a debug message.
---The most amount of logging, logs only if the log level is set to `debug` or `vim.log.levels.DEBUG`
---@vararg any
function Logger:debug(...)
  if self.level == "debug" or self.level == vim.log.levels.DEBUG then
    local message = print_line(self, ...)
    log(message, vim.log.levels.DEBUG, self)
  end
end

---Log an info message.
---The default level of logging, logs if the log level is set to `info`, `debug`, or `vim.log.levels.DEBUG` or `vim.log.levels.INFO`
---@vararg any
function Logger:info(...)
  local valid_values = { "info", "debug", vim.log.levels.DEBUG, vim.log.levels.INFO }

  if vim.tbl_contains(valid_values, self.level) then
    local message = print_line(self, ...)
    log(message, vim.log.levels.INFO, self)
  end
end

---Log a warning message.
---Logs if the log level is set to `warn`, `info`, `debug`, or `vim.log.levels.DEBUG` or `vim.log.levels.INFO` or `vim.log.levels.WARN`
---@vararg any
function Logger:warn(...)
  local valid_values = { "info", "debug", "warn", vim.log.levels.DEBUG, vim.log.levels.INFO, vim.log.levels.WARN }

  if vim.tbl_contains(valid_values, self.level) then
    local message = print_line(self, ...)
    log(message, vim.log.levels.WARN, self)
  end
end

---Log an error message.
---Logs if the log level is set to `error`, `warn`, `info`, `debug`, or `vim.log.levels.DEBUG` or `vim.log.levels.INFO` or `vim.log.levels.WARN` or `vim.log.levels.ERROR`
---@vararg any
function Logger:error(...)
  local message = print_line(self, ...)
  log(message, vim.log.levels.ERROR, self)
end

function Logger:clear()
  buffer_id = buffer.delete_by_name(LOG_BUFFER_NAME)
  if buffer_id == nil then
    svim_logger.warn('No buffer ' .. buffer_name .. ' found for deletion.')
  end
end

function Logger:get_buffer_lines()
  lines = buffer.get_lines_by_name(LOG_BUFFER_NAME)
  if lines == nil then
    svim_logger.warn('No buffer ' .. buffer_name .. ' found for getting lines.')
  end
  return lines
end

function Logger:get_buffer_string()
  buffer_string = ''
  for _, line in ipairs(self:get_buffer_lines()) do
    buffer_string = buffer_string .. line .. '\n'
  end
  return buffer_string
end

-- function Logger.view(level)
  -- local info = ''
  -- for _, log in ipairs(logs) do
    -- if log.level >= level then
      -- info = info .. log.str .. '\n'
    -- end
  -- end
  -- return info
-- end

return Logger
