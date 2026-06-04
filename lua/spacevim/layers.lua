--=============================================================================
-- layer.lua --- spacevim layer module
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local M = {}
local vim_compatible = require('spacevim.api.vim.compatible')
local spsys = require('spacevim.api').import('system')

-- local mt = {
-- __newindex = function(layer, layer_name, layer_obj)
-- rawset(layer, layer_name, layer_obj)
-- end,
-- __index = function(layer, layer_name)
-- if vim.g ~= nil then
-- return vim.g['spacevim_' .. key] or nil
-- else
-- return vim_compatible.eval('get(g:, "spacevim_' .. key .. '", v:null)')
-- end
-- end
-- }
-- setmetatable(M, mt)

function M.getEnabled()
  -- Function for getting Vimscript layers which are added by old plugin manager dein bey now.
  -- return vim.fn['spacevim#layers#get']()
  -- TODO: Hardcoded the only new Lua layer by now.
  return {'codingagent'}
end

function M.isLoaded(layer)
  return vim_compatible.call('spacevim#layers#isLoaded', layer) == 1
end

local function find_layers()
  local layers = vim_compatible.fn.globpath(vim_compatible.vim_options.runtimepath, 'autoload/spacevim/layers/**/*.vim', 0, 1)
  local pattern = '/autoload/spacevim/layers/'
  local rst = {}
  for _, layer in pairs(layers) do
    local name = layer:gsub('.+spacevim[\\/]layers[\\/]', ''):gsub('.vim$', ''):gsub('[\\/]', '/')
    local status = ''
    local url = ''
    local website = ''
    if name == 'lsp' then
      url = 'language-server-protocol'
    else
      url = name
    end
    if vim_compatible.fn.filereadable(vim_compatible.fn.expand('~/.spacevim/docs/layers/' .. url .. '.md')) == 1 then
      website = 'https://spacevim.org/layers/' .. url .. '/'
    else
      website = 'no exists'
    end
    name = vim_compatible.fn.substitute(name, '/', '#','g')
    if M.isLoaded(name) then
      status = 'loaded'
    else
      status = 'not loaded'
    end
    if status == 'loaded' then
      table.insert(rst, '+ ' .. name .. ':' .. vim_compatible.fn['repeat'](' ', 25 - vim_compatible.fn.len(name)) .. status .. vim_compatible.fn['repeat'](' ', 10) .. website)
    else
      table.insert(rst, '- ' .. name .. ':' .. vim_compatible.fn['repeat'](' ', 21 - vim_compatible.fn.len(name)) .. status .. vim_compatible.fn['repeat'](' ', 10) .. website)
    end
  end
  return rst
end

local function list_layers()
  vim.cmd('tabnew spacevimLayers')
  vim.cmd('nnoremap <buffer> q :q<cr>')
  vim.cmd('setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell')
  vim.cmd('setf spacevimLayerManager')
  vim.cmd('nnoremap <silent> <buffer> q :bd<CR>')
  local info = {'spacevim layers:', ''}
  for k,v in pairs(find_layers()) do table.insert(info, v) end
  vim_compatible.fn.setline(1,info)
  vim.cmd('setl nomodifiable')
end

function M.load(layer, ...)
  if layer == '-l' then
    list_layers()
    return
  end
end

return M
