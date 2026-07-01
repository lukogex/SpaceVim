local Utils = {}

local logger = require("spacevim.api.logger"):new({ name = "utils" })

function Utils.prequire(...)
    local exists, m = pcall(require, ...)
    if(exists) then
      return m
    else
      -- pcall returns an error in case the required module does not exist.
      logger:error('Cannot find module ' .. m)
    end
    return nil
end

function Utils.table_contains(t, value)
  for _, v in pairs(t) do
    if v == value then 
      return true 
    end
  end
  return false
end

return Utils
