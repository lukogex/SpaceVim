--=============================================================================
-- api.lua --- lua api plugin
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local M = {}


-- local logger = require('spacevim.logger')

-- TODO: For what? Setting package.loaded to nil for this module makes it loading it again next time.
function M.import(name)
    local p = 'spacevim.api.' .. name
    local ok, rst = pcall(require, p)
    if ok then
        package.loaded[p] = nil
        return rst
    else
        return nil
    end
end

return M
