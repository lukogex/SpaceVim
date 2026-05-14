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

-- Spacevim initialization

spacevim.initialize()

-- logger.info('Lazy configuration.')
-- require('config.lazy')

-- Why is plugin manager install not working? Is working now, just keep for history.
-- Now the custom plugins seems not to be loaded into rtp, maybe because lazy overwrites the install paths?
-- vim.opt.rtp:append('/home/lkranabetter/workspace/lukogex/spacevim/bundle/dein.vim')

logger.info('Runtimepath before Spacevim loads layers and plugins: ' .. vim.inspect(vim.opt.rtp:get()))

-- TODO: On the long run spacevim#end plugin isntallation should be done by lazy.
vim.cmd 'call spacevim#end()'

logger.info('Spacevim finished loading.')
