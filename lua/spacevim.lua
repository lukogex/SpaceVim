local Spacevim = {}

local svim_file = require('spacevim.api.file')
local logger = require('spacevim.logger')

local GLOBAL_VARS_PREFIX = 'svim_'

Spacevim.vars = {
  -- Set the log level of spacevim.
  -- Either a string or number, see `:h vim.log.levels`.
  -- ERROR | WARN | INFO | DEBUG | TRACE
  log_level = vim.log.levels.DEBUG
}

function Spacevim.arguments()
  args = {}

  for k, v in pairs(vim.v.argv) do
    if k == 1 then
      args['nvim_bin'] = svim_file.absolute_path(vim.v.argv[k])

      -- TODO: We should check here if its an asdf installation and set the paths accordingly!
      args['nvim_lib'] = '/home/lkranabetter/.asdf/installs/neovim/0.11.7/lib/nvim'
      args['nvim_runtime'] = '/home/lkranabetter/.asdf/installs/neovim/0.11.7/share/nvim/runtime'
    end
    if v == '-u' then
      args['vimrc'] = svim_file.absolute_path(vim.v.argv[k + 1])
    end
    if k == #vim.v.argv then
      -- TODO: This check might not work in all cases right? How could we parse them more relyable?
      if string.match(vim.v.argv[k - 1], '^-.') then
        args['file'] = svim_file.absolute_path(vim.fn.getcwd())
      else
        args['file'] = svim_file.absolute_path(vim.v.argv[k])
      end
    end
  end

  args['root_dir'] = vim.fn.fnamemodify(args['vimrc'], ':h')

  return args
end

function Spacevim.init()
  logger.info('Spacevim initialization.')
  
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
 
  Spacevim.global_variables()

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
  Spacevim.config()
  Spacevim.keybindings()

  logger.info('Runtimepath after Spacevim initialization: ' .. vim.inspect(vim.opt.rtp:get()))

  require('spacevim.plugins').init()

  vim.cmd 'call spacevim#end()'

  logger.info('Spacevim is ready with runtimepath: ' .. vim.inspect(vim.opt.rtp:get()))
end

function Spacevim.global_variables()
  -- Set global variables from deprecated Vimscript.
  vim.cmd('call spacevim#spacevim_variables()')

  for k, v in pairs(Spacevim.vars) do
    vim.g[GLOBAL_VARS_PREFIX .. k] = v
  end
end

function Spacevim.config()
  logger.info('Load Spacevim global configuration.')
  vim.cmd 'call spacevim#custom#load_glob_conf()'

  if svim_file.absolute_path(vim.fn.getcwd()) == os.getenv('HOME') then
    logger.info('Current directory is $HOME, skip local configuration.')
  else
    vim.cmd 'call spacevim#custom#load_local_conf()'
  end
  
  vim.cmd('call spacevim#spacevim_variables_validation()')
end

function Spacevim.keybindings()
  if vim.fn.has('timers') then
    vim.cmd(string.format('call timer_start(%d, "spacevim#default#keyBindings")', vim.g.spacevim_lazy_conf_timeout))
  else
    vim.cmd 'call spacevim#default#keyBindings()'
  end
end

return Spacevim
