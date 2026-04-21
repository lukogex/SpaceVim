-- Set default encoding to utf-8
-- vim.opt.encoding = 'utf-8'
-- vim.cmd 'scriptencoding utf-8'

-- Enable nocompatible
if vim.opt.compatible:get() then
  vim.opt.compatible = false
end

local init_file = debug.getinfo(1, "S").source:sub(2)
local root_dir = vim.fn.fnamemodify(vim.fn.resolve(init_file), ':p:h'):gsub('\\', '/')
-- vim.g._spacevim_root_dir = root_dir
vim.g._spacevim_root_dir = '/home/lkranabetter/workspace/lukogex/spacevim/'

vim.cmd 'call spacevim#logger#info("Loading Spacevim from: " . g:_spacevim_root_dir)'

print(root_dir)

-- Handle nvim-qt runtimepath (move to front)
-- Even when not supported explicitely lets keep this to not break when a user adds it to the runtimepath.
-- The nvim-qt check is used to ensure that any runtime paths related to the Neovim-Qt GUI are moved to the front of the runtimepath.
-- nvim-qt often provides its own set of scripts (like those for handling GUI-specific features, fonts, or windowing).
-- If these paths are buried deep in the runtimepath, they might be overridden by other plugins or SpaceVim's own defaults, leading to broken GUI functionality.
-- if vim.fn.has('nvim') then
  -- local rtps = {}
  -- for rtp in vim.split(vim.opt.rtp:get(), ',') do
    -- if rtp:match('nvim%-qt') then
      -- table.insert(rtps, 1, rtp)
    -- else
      -- table.insert(rtps, rtp)
    -- end
  -- end
  -- vim.opt.rtp = table.concat(rtps, ',')
-- end

-- Python host
local python_host_prog = os.getenv('PYTHON_HOST_PROG')
if python_host_prog and python_host_prog ~= '' then
  vim.g.python_host_prog = python_host_prog
end

local python3_host_prog = os.getenv('PYTHON3_HOST_PROG')
if python3_host_prog and python3_host_prog ~= '' then
  vim.g.python3_host_prog = python3_host_prog
end

print("Spacevim initialization.")
-- Spacevim initialization
vim.cmd 'call spacevim#begin()'
vim.cmd 'call spacevim#custom#load()'

print("Lazy configuration.")
require("config.lazy")

if vim.fn.has('timers') then
  vim.cmd(string.format('call timer_start(%d, "spacevim#default#keyBindings")', vim.g.spacevim_lazy_conf_timeout))
else
  vim.cmd 'call spacevim#default#keyBindings()'
end

vim.cmd 'call spacevim#end()'
