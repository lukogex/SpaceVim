local M = {}

local logger = require('spacevim.logger')

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
  M.configuration()
end

function M.configuration()
  logger.info('Load Spacevim global configuration.')
  vim.cmd 'call spacevim#custom#load_glob_conf()'

  if M.absolute_path(vim.fn.getcwd()) == os.getenv('HOME') then
    logger.info('Current directory is $HOME, skip local configuration.')
  else
    vim.cmd 'call spacevim#custom#load_local_conf()'
  end
  
  vim.cmd('call spacevim#spacevim_variables_validation()')
end

return M
