local spacevim = require('spacevim')
local logger = require('spacevim.logger')

-- Initialize Spacevim runtimepath

local args = spacevim.arguments()

-- Set related environment variables to be sure its taken everywhere consistently.
vim.env.MYVIMRC = args['vimrc']
-- VIMRUNTIME is used by lazy setup when rewriting rtp and needs to point to the asdf installation.
vim.env.VIMRUNTIME = args['nvim_runtime']

-- Reset runtimepath with asdf installation configs.
vim.opt.rtp = {}
vim.opt.rtp:append(args['nvim_lib'])
vim.opt.rtp:append(args['nvim_runtime'])
vim.opt.rtp:append(args['root_dir'])

logger.info('Spacevim started with arguments: ' .. vim.inspect(vim.v.argv))
logger.info('Parsed arguments: ' .. vim.inspect(args))
logger.info('Initial runtimepath: ' .. vim.inspect(vim.opt.rtp:get()))

logger.info('Base directory configuration:')
logger.info('Config directory ($XDG_CONFIG_HOME): ' .. vim.fn.stdpath("config"))
logger.info('Data directory ($XDG_DATA_HOME): ' .. vim.fn.stdpath("data"))
logger.info('Run directory ($XDG_RUNTIME_DIR): ' .. vim.fn.stdpath("run"))
logger.info('State directory ($XDG_STATE_HOME): ' .. vim.fn.stdpath("state"))
logger.info('Cache directory ($XDG_CACHE_HOME): ' .. vim.fn.stdpath("cache"))
logger.info('Log directory: ' .. vim.fn.stdpath("log"))

-- Set global variables

-- Spacevim root directory path needs trailing slash for further concatinations.
vim.g._spacevim_root_dir = args['root_dir'] .. '/'
vim.g._spacevim_enter_dir = args['file']

-- Read needed environment variables
local python_host_prog = os.getenv('PYTHON_HOST_PROG')
if python_host_prog and python_host_prog ~= '' then
  logger.info('$PYTHON_HOST_PROG is not empty, setting g:python_host_prog:' .. python_host_prog)
  vim.g.python_host_prog = python_host_prog
end

local python3_host_prog = os.getenv('PYTHON3_HOST_PROG')
if python3_host_prog and python3_host_prog ~= '' then
  logger.info('$PYTHON3_HOST_PROG is not empty, setting g:python3_host_prog:' .. python3_host_prog)
  vim.g.python3_host_prog = python3_host_prog
end

-- Initialize Spacevim

spacevim.init()
