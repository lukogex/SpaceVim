---@class Layer
---@field add_plugin_spec function
---@field add_plugin_opts function
---@field mappings function
---@field get_spec function
local Layer = {
  _type = '',
  name = '',
  plugins_spec = {}
}

local logger = require("spacevim.api.logger"):new({ name = "layer" })
local utils = require('spacevim.utils')

local types = {'codingagent'}

---Constructor for Layer class.
---@param _type string
---@param name string
function Layer:new(_type, name)
  local layer = {}
  if utils.table_contains(types, _type) then
    layer.name = name
    layer._type = _type

    local mt = {}
    mt.__index = function(t, k)
      local value = self[k]
      if type(value) == "function" then
        return function(...)
          return value(...)
        end
      else
        return value
      end
    end
    setmetatable(layer, mt)
  
  else
    logger:error('No type ' .. _type .. ' available for layers')
  end
  return layer
end

function Layer:add_plugin_spec(name, spec)
  self.plugins_spec[name] = spec
end

function Layer:add_plugin_opts(name, opts)
  self.plugins_spec[name].opts = opts
end

---https://neovim.io/doc/user/lua-guide/#_mappings
---https://neovim.io/doc/user/map/
function Layer:mappings()
  logger:warn('No key mappings defined for layer ' .. self.name)
end

---@return table spec Lazy plugin manager spec.
function Layer:get_spec()
  local spec = {}
  if self.plugins_spec then
    for _, v in pairs(self.plugins_spec) do
      table.insert(spec, v) 
    end 
  else
    logger:warn('No plugins defined for layer ' .. self.name)
  end
  return spec
end

return Layer
