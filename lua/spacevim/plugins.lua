--=============================================================================
-- plugins.lua --- plugin manager
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================
local Plugins = {}

local logger = require("spacevim.api.logger"):new({ name = "plugins" })
local utils = require('spacevim.utils')

function Plugins.init()
  Plugins.manager_install()
  Plugins.manager_config()
  -- Load plugins from Vimscript layers
  vim.cmd 'call spacevim#plugins#load_plugins()'
  Plugins.disable(vim.g.spacevim_disabled_plugins)
  vim.cmd 'call spacevim#plugins#end()'
end

function Plugins.manager_install()
  -- Deprecated plugin manager dein is part of bundle.
  vim.opt.rtp:prepend(vim.g._spacevim_root_dir .. 'bundle/dein.vim')
  
  -- Install new plugin manager lazy.
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorPluginssg" },
        { out, "WarningPluginssg" },
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

function Plugins.manager_setup()
  -- Make sure to setup `mapleader` and `maplocalleader` before
  -- loading lazy.nvim so that mappings are correct.
  -- This is also a good place to setup other settings (vim.opt)
  -- vim.g.mapleader = " "
  -- vim.g.maplocalleader = "\\"

  require("lazy").setup({
    ui = {
      custom_keys = {
        -- You can define custom key maps here. If present, the description will
        -- be shown in the help menu.
        -- To disable one of the defaults, set it to false.

        ["<localleader>l"] = false,

        ["<localleader>i"] = false,

        ["<localleader>t"] = false,
      }
    },
    spec = Plugins.load_plugins(),
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
    performance = {
      cache = {
        enabled = true,
      },
      reset_packpath = true, -- reset the package path to improve startup time
      rtp = {
        reset = false, -- reset the runtime path to $VIMRUNTIME and your config directory
        ---@type string[]
        -- TODO: We could use this to replace all bundle plugins!
        paths = {}, -- add any custom paths here that you want to includes in the rtp
        ---@type string[] list any plugins you want to disable here
        disabled_plugins = {
          -- "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          -- "tarPlugin",
          -- "tohtml",
          -- "tutor",
          -- "zipPlugin",
        },
      },
    },
  })
end

function Plugins.manager_config()
  -- Add the deprecated dein plugin manager.
  Plugins.initializePluginFuzzyFinder()
  -- Initializes the plugin manager, sets up the runtimepath, and prepares for plugin declarations.
  vim.cmd 'call dein#begin(g:spacevim_plugin_bundle_dir)'
  -- TODO: What is the dein#add function doing? I commented out this call as it adds it a second time to runtimepath.
  -- vim.cmd 'call dein#add(g:_spacevim_root_dir . "bundle/dein.vim", { "merged" : 0})'
  -- Add new Spacevim plugin manager.
  -- This load plugins from Lua layers by now.
  logger:info('Lazy plugin manager configuration.')
  logger:info("Runtimepath before lazy setup.")
  logger:info(vim.inspect(vim.opt.rtp:get()))

  Plugins.manager_setup()
end

function Plugins.initializePluginFuzzyFinder()
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
function Plugins.load_plugins()
  local plugins = {}
  for _, layer in ipairs(require('spacevim.layers').get_enabled()) do
    logger:debug('Get ' .. layer .. ' layer plugins list.')
    vim.g._spacevim_plugin_layer = layer
    
    -- For new layers we simply return plugin spec for lazy.
    -- for _, plugin in ipairs(Plugins.for_layer(layer)) do
      -- if vim.fn.len(plugin) == 2 then
        -- Plugins.add(plugin[1], extend(plugin[2], {overwrite = 1}))
        -- if Plugins.tab(vim.fn.split(plugin[1], '/')[-1]) and plugin[1].loadconf then
          -- Plugins.defind_hooks(plugin[1], '/')
        -- end
        -- if Plugins.tab(vim.fn.split(plugin[1], '/')[-1]) and plugin[1].loadconf_before then
          -- Plugins.loadPluginBefore(plugin[1], '/')
        -- end
      -- else
        -- Plugins.add(plugin[1], {overwrite = 1})
      -- end
    -- end

    table.insert(plugins, Plugins.for_layer(layer))
  end
  -- print('Plugin spec: ' .. vim.inspect(plugins))
  return plugins
end

-- Returns the plugin spec for lazy for this layer.
function Plugins.for_layer(name)
  local layer = utils.prequire('spacevim.layers.' .. name)
  if layer and layer.plugins ~= nil then
    logger:info('Found layer ' .. name)
    return layer.plugins()
  end
  logger:info('No layer found for ' .. layer)
  return {}
end

local function loadLayerConfig(layer)
  logger:debug('load ' .. layer .. ' layer config')
  local ok, l = pcall(require, 'spacevim.layers.' .. layer)
  if ok and l.config ~= nil then
    l.config()
  end
end

local plugins_argv = {'-update', '-openurl'}

function Plugins.complete_plugs(ArgLead, CmdLine, CursorPos)
    
end

function Plugins.Plugin(...)
    
end

function Plugins.disable(plugins)
  logger:info('Disable plugins: ' .. vim.inspect(plugins))
  for name in ipairs(plugins) do
    vim.cmd(string.format('call dein#disable(%s)', name))
  end
end

function Plugins.get(...)
    
end

-- can not use Plugins.end
function Plugins._end()
    
end

function Plugins.defind_hooks(bundle)
    
end

local plugins = {}

local function parser(args)
    
end

vim.g._spacevim_plugins = {}

function Plugins.add(repo, ...)
    
end

function Plugins.tap(plugin)
    
end

function Plugins.loadPluginBefore(plugin)
    
end

return Plugins
