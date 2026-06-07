--=============================================================================
-- plugins.lua --- plugin manager
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')
local utils = require('spacevim.utils')

function M.init()
  M.manager_install()
  M.manager_config()
  -- Load plugins from Vimscript layers
  vim.cmd 'call spacevim#plugins#load_plugins()'
  M.disable(vim.g.spacevim_disabled_plugins)
  vim.cmd 'call spacevim#plugins#end()'
end

function M.manager_install()
  -- Deprecated plugin manager dein is part of bundle.
  vim.opt.rtp:prepend(vim.g._spacevim_root_dir .. 'bundle/dein.vim')
  
  -- Install new plugin manager lazy.
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end

  -- Needs not to be added, else module 'lazy' is not found.
  vim.opt.rtp:prepend(lazypath)
  -- vim.opt.rtp:append(lazypath)
end

function M.manager_config()
  -- Add the deprecated dein plugin manager.
  M.initializePluginFuzzyFinder()
  -- Initializes the plugin manager, sets up the runtimepath, and prepares for plugin declarations.
  vim.cmd 'call dein#begin(g:spacevim_plugin_bundle_dir)'
  -- TODO: What is the dein#add function doing? I commented out this call as it adds it a second time to runtimepath.
  -- vim.cmd 'call dein#add(g:_spacevim_root_dir . "bundle/dein.vim", { "merged" : 0})'
  -- Add new Spacevim plugin manager.
  -- This load plugins from Lua layers by now.
  logger.info('Lazy plugin manager configuration.')
  logger.info("Runtimepath before lazy setup.")
  logger.info(vim.inspect(vim.opt.rtp:get()))

  require('config.lazy')
end

function M.initializePluginFuzzyFinder()
  addedPluginsFuzzyFinder = vim.g.unite_source_menu_menus or vim.empty_dict()
  addedPluginsFuzzyFinder['AddedPlugins'] = {
    description = 'All the Added plugins                    <Leader>fp',
    command_candidates = {},
  }
  -- Fuzzy finder layers use the 'unite_source_menu_menus' variable from the deprecated unite fuzzy finder layer.
  -- It has been removed already but the variable used is still the old one.
  vim.g.unite_source_menu_menus = addedPluginsFuzzyFinder
end

local function extend(t1, t2)
  for k, v in ipairs(t2) do
    t1[k] = v
  end
  return t1
end

-- TODO: This function will change with new plugin manager, adapt comments!
-- The check len(plugin) == 2 determines whether the plugin specification includes options or not:
-- Two formats supported:
-- 1. With options: ['owner/repo', {'merged': 0, 'loadconf': 1}] - length 2
-- 2. Without options: ['owner/repo'] - length 1
function M.load_plugins()
  local plugins = {}
  for _, layer in ipairs(require('spacevim.layers').getEnabled()) do
    logger.debug('Get ' .. layer .. ' layer plugins list.')
    vim.g._spacevim_plugin_layer = layer
    
    -- For new layers we simply return plugin spec for lazy.
    -- for _, plugin in ipairs(M.getLayerPlugins(layer)) do
      -- if vim.fn.len(plugin) == 2 then
        -- M.add(plugin[1], extend(plugin[2], {overwrite = 1}))
        -- if M.tab(vim.fn.split(plugin[1], '/')[-1]) and plugin[1].loadconf then
          -- M.defind_hooks(plugin[1], '/')
        -- end
        -- if M.tab(vim.fn.split(plugin[1], '/')[-1]) and plugin[1].loadconf_before then
          -- M.loadPluginBefore(plugin[1], '/')
        -- end
      -- else
        -- M.add(plugin[1], {overwrite = 1})
      -- end
    -- end

    table.insert(plugins, M.getLayerPlugins(layer))
  end
  return plugins
end

-- Returns the plugin spec for lazy for this layer.
function M.getLayerPlugins(layer)
  local layerModule = utils.prequire('spacevim.layers.' .. layer)
  if layerModule and layerModule.plugins ~= nil then
    logger.info('Found layer ' .. layer)
    return layerModule.plugins()
  end
  logger.info('No layer found for ' .. layer)
  return {}
end

local function loadLayerConfig(layer)
  logger.debug('load ' .. layer .. ' layer config')
  local ok, l = pcall(require, 'spacevim.layers.' .. layer)
  if ok and l.config ~= nil then
    l.config()
  end
end

local plugins_argv = {'-update', '-openurl'}

function M.complete_plugs(ArgLead, CmdLine, CursorPos)
    
end

function M.Plugin(...)
    
end

function M.disable(plugins)
  logger.info('Disable plugins: ' .. vim.inspect(plugins))
  for name in ipairs(plugins) do
    vim.cmd(string.format('call dein#disable(%s)', name))
  end
end

function M.get(...)
    
end

-- can not use M.end
function M._end()
    
end

function M.defind_hooks(bundle)
    
end

local plugins = {}

local function parser(args)
    
end

vim.g._spacevim_plugins = {}

function M.add(repo, ...)
    
end

function M.tap(plugin)
    
end

function M.loadPluginBefore(plugin)
    
end

return M
