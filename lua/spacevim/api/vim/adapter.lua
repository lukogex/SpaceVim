---This is an adapter interface to the Neovim Lua standard library.
---Its purpose is to decouple Spacevim by preventing direct calls and to have a better overview about the calls we do.
---Goal is to reduce dublication, consolidate calls and have one common layer to interact with Neovim.
---TODO: Intergrate compatibility.lua here!
---
---In general prefer the Lua standard library, then `vim.api`, then `vim.fn` when I write Lua code.
---For example the standard library for `vim.cmd()` calls the respective `vim.api` things automatically.
local Adapter = {}

local logger = require("spacevim.api.logger"):new({ name = "adapter" })

---The Neovim API, it is written in C for use in remote plugins and GUIs.
---The API is primarily intended for communicating with a separate Neovim process through remote procedure calls (RPC).
---https://neovim.io/doc/user/api/
Adapter.api = setmetatable({}, {
  __index = function(t, k)
    local _api
    if vim.api ~= nil and vim.api[k] ~= nil then
      _api = function(...)
        return vim.api[k](...)
      end
    else
      _api = function(...)
        return Adapter.call(k, ...)
      end
    end
    t[k] = _api
    return _api
  end,
})

---The Vim standard library so to say, inherited from Vim, it contains everything Vim has.
---Ex-commands and vimscript-functions as well as user-functions in Adapterscript.
---These are accessed through `vim.cmd()` and `vim.fn` respectively.
---https://neovim.io/doc/user/lua/#vim.fn
---
---Some links to docs to help me accesing them faster:
---@field fnamemodify function https://neovim.io/doc/user/vimfn/#fnamemodify()
---       Lua: Prefer vim.fs.dirname(), vim.fs.basename(), vim.fs.abspath(), and vim.fs.normalize() for common path	modifiers; modifier coverage differs.
Adapter.fn = setmetatable({}, {
  __index = function(t, k)
    local _fn
    if vim.fn ~= nil and vim.fn[k] ~= nil then
      _fn = function(...)
        return vim.fn[k](...)
      end
    elseif vim.api ~= nil and vim.api[k] ~= nil then
      _fn = function()
        error(string.format('Tried to call API function with vim.fn: use vim.api.%s instead', k))
      end
    else
      _fn = function(...)
        return Adapter.call(k, ...)
      end
    end
    t[k] = _fn
    return _fn
  end,
})

---https://neovim.io/doc/user/lua/#vim.fs
Adapter.fs = setmetatable({}, {
  __index = function(t, k)
    local _fs
    if vim.fs ~= nil and vim.fs[k] ~= nil then
      _fs = function(...)
        return vim.fs[k](...)
      end
    end
    t[k] = _fs
    return _fs
  end,
})

---Predefined variables
---vim.v is an empty Lua table wrapper equipped with a metatable (__index and __newindex) that dynamically fetches variables from Neovim's internal C/Adapterscript core on demand.
---Thats why we cannot treat it as usual Lua table and must call each variable explicitely.
---https://neovim.io/doc/user/vvars/
---
---@field argv table Command line arguments Nvim was invoked with. 
Adapter.v = setmetatable({}, {
  __index = function(t, k)
    local success, value = pcall(vim.api.nvim_get_vvar, k)
    -- TODO: This is called so early that we miss full rtp I think, thus logger is not working.
    -- logger:debug('Read variable ' .. k .. ' with value ' .. vim.inspect(value))
    if success then
      t[k] = value
    end
    return value
  end,
})

---https://neovim.io/doc/user/lua/#vim.call()
---Equivalent to `vim.fn[func]({...})`
function Adapter.call(func, ...)
  if vim.call ~= nil then
    return vim.call(func, ...)
  else
    if vim.api ~= nil then
      return vim.api.nvim_call_function(func, { ... })
    else
      -- TODO: Is this safe to remove?
      vim.command('let g:lua_rst = ' .. func .. '(' .. build_argv({ ... }) .. ')')
      return M.eval('g:lua_rst')
    end
  end
end

function Adapter.getchar2nr(...)
  local status, ret = pcall(vim.fn.getchar, ...)
  if not status then
    ret = 3
  end
  if type(ret) == 'number' then
    return ret
  else
    return vim.fn.char2nr(ret)
  end
end

function Adapter.empty(expr)
  return vim.fn.empty(expr) == 1
end

function Adapter.executable(bin)
  return vim.fn.executable(bin) == 1
end

return Adapter
