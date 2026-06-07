local M = {}

local logger = require('spacevim.logger')

function M.prequire(...)
    local exists, m = pcall(require, ...)
    if(exists) then
      return m
    else
      -- pcall returns an error in case the required module does not exist.
      logger.error('Cannot find module ' .. m)
    end
    return nil
end

return M
