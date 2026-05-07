
function absolute_path(path)
  return vim.fn.fnamemodify(vim.fn.resolve(path), ':p')
end

function vim_arguments()
  args = {}

  for k, v in pairs(vim.v.argv) do
    if k == 1 then
      args["nvim_bin"] = absolute_path(vim.v.argv[k])

      -- TODO: We should check here if its an asdf installation and set the paths accordingly!
      args["nvim_lib"] = "/home/lkranabetter/.asdf/installs/neovim/0.10.4/lib/nvim"
      args["nvim_runtime"] = "/home/lkranabetter/.asdf/installs/neovim/0.10.4/share/nvim/runtime"
    end
    if v == "-u" then
      args["vimrc"] = absolute_path(vim.v.argv[k + 1])
    end
  end

  args["root_dir"] = vim.fn.fnamemodify(args["vimrc"], ':h')

  return args
end

local args = vim_arguments()

print(vim.inspect(vim.v.argv))
print(vim.inspect(args))

vim.env.MYVIMRC = args["vimrc"]
-- VIMRUNTIME is used by lazy setup when rewriting rtp and needs to point to the asdf installation.
vim.env.VIMRUNTIME = args["nvim_runtime"]

print(vim.env.MYVIMRC)
print(vim.env.VIMRUNTIME)

-- Reset runtimepath with asdf installation configs.
vim.opt.rtp = {}
vim.opt.rtp:append(args["nvim_lib"])
vim.opt.rtp:append(args["nvim_runtime"])
vim.opt.rtp:append(args["root_dir"])

-- Spacevim root directory path needs trailing slash for further concatinations.
vim.g._spacevim_root_dir = args["root_dir"] .. "/"

print("Spacevim initialization.")
vim.cmd 'call spacevim#begin()'
vim.cmd 'call spacevim#custom#load()'

local logger = require('spacevim.logger')

print("Lazy configuration.")
require("config.lazy")

-- Why is plugin manager install not working? Is working now, just keep for history.
-- vim.opt.rtp:append("/home/lkranabetter/workspace/lukogex/spacevim/bundle/dein.vim")

print("Runtimepath before Spacevim plugins.")
print(vim.inspect(vim.opt.rtp:get()))

vim.cmd 'call spacevim#end()'
