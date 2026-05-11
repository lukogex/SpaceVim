local M = {}

-- TODO: Move to a file utils module!
function M.absolute_path(path)
  return vim.fn.fnamemodify(vim.fn.resolve(path), ':p')
end

function M.arguments()
  args = {}

  for k, v in pairs(vim.v.argv) do
    if k == 1 then
      args['nvim_bin'] = M.absolute_path(vim.v.argv[k])

      -- TODO: We should check here if its an asdf installation and set the paths accordingly!
      args['nvim_lib'] = '/home/lkranabetter/.asdf/installs/neovim/0.10.4/lib/nvim'
      args['nvim_runtime'] = '/home/lkranabetter/.asdf/installs/neovim/0.10.4/share/nvim/runtime'
    end
    if v == '-u' then
      args['vimrc'] = M.absolute_path(vim.v.argv[k + 1])
    end
    if k == #vim.v.argv then
      -- TODO: This check might not work in all cases right? How could we parse them more relyable?
      if string.match(vim.v.argv[k - 1], '^-.') then
        args['file'] = M.absolute_path(vim.fn.getcwd())
      else
        args['file'] = M.absolute_path(vim.v.argv[k])
      end
    end
  end

  args['root_dir'] = vim.fn.fnamemodify(args['vimrc'], ':h')

  return args
end

function M.initialize()
  local logger = require('spacevim.logger')
  
  logger.info('Set Vim options.')
  -- This command sets Vim's internal locale to `en_US.UTF-8`.
  -- It affects:
  -- - **Message language** — forces all Vim messages/errors to English regardless of system locale
  -- - **Character encoding** — ensures UTF-8 handling for the session
  -- - **Collation/sorting** — uses en_US sorting order within Vim
  vim.cmd.language('en_US.UTF-8')

  -- Is the default anyway but to make it visible.
  vim.opt.encoding = 'utf-8'
  vim.opt.fileencodings = 'utf-8'
  
  vim.cmd('call spacevim#spacevim_variables()')

  local spwelcome = vim.api.nvim_create_augroup('SPwelcome', { clear = true })

  vim.api.nvim_create_autocmd('VimEnter', {
    group = spwelcome,
    pattern = '*',
    callback = function()
      vim.cmd('call spacevim#welcome()')
    end,
  })
  
  local default = require('spacevim.default')
  default.options()
  default.layers()

  vim.cmd('call spacevim#commands#load()')
end

function M.eval(l)
    if vim.api ~= nil then
        return vim.api.nvim_eval(l)
    else
        return vim.eval(l)
    end
end

if vim.command ~= nil then
    function M.cmd(command)
        return vim.command(command)
    end
else
    function M.cmd(command)
        return vim.api.nvim_command(command)
    end
end

-- there is no want to call viml function in old vim and neovim

local function build_argv(...)
    local str = ''
    for index, value in ipairs(...) do
        if str ~= '' then
            str = str .. ','
        end
        if type(value) == 'string' then
            str = str .. '"' .. value .. '"'
        elseif type(value) == 'number' then
            str = str .. value
        end
    end
    return str
end

function M.call(funcname, ...)
    if vim.call ~= nil then
        return vim.call(funcname, ...)
    else
        if vim.api ~= nil then
            return vim.api.nvim_call_function(funcname, {...})
        else
            -- call not call vim script function in lua
            vim.command('let g:lua_rst = ' .. funcname .. '(' .. build_argv({...}) .. ')')
            return M.eval('g:lua_rst')
        end
    end
end

-- this is for Vim and old neovim
M.fn = setmetatable({}, {
        __index = function(t, key)
            local _fn
            if vim.api ~= nil and vim.api[key] ~= nil then
                _fn = function()
                    error(string.format("Tried to call API function with vim.fn: use vim.api.%s instead", key))
                end
            else
                _fn = function(...)
                    return M.call(key, ...)
                end
            end
            t[key] = _fn
            return _fn
        end
    })

-- This is for vim and old neovim to use vim.o
M.vim_options = setmetatable({}, {
        __index = function(t, key)
            local _fn
            if vim.api ~= nil then
                -- for neovim
                return vim.api.nvim_get_option(key)
            else
                -- for vim
                _fn = M.eval('&' .. key)
            end
            t[key] = _fn
            return _fn
        end
    })

-- this function is only for vim
function M.has(feature)
    return M.eval('float2nr(has("' .. feature .. '"))')
end

function M.echo(msg)
    if vim.api ~= nil then
        vim.api.nvim_echo({{msg}}, false, {})
    else
        vim.command('echo ' .. build_argv({msg}))
    end
end

return M
