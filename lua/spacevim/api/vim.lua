---This is an interface to the Nvim Lua standard library.
---Its purpose is to decouple Spacevim by preventing direct calls and to have a better overview about calls we do.
---Goal is to reduce dublication and have one common layer to interact with Neovim.
---Furthermore this might help in future compatibility implementations.
---TODO: Intergrate compatibility.lua here!
---
---In general prefer the Lua standard library, then `vim.api`, then `vim.fn` when I write Lua code.
---For example the standard library for `vim.cmd()` calls the respective `vim.api` things automatically.
local Vim = {}

local logger = require("spacevim.api.logger"):new({ name = "vim" })

---The Neovim API, it is written in C for use in remote plugins and GUIs.
---The API is primarily intended for communicating with a separate Neovim process through remote procedure calls (RPC).
---https://neovim.io/doc/user/api/
Vim.api = setmetatable({}, {
  __index = function(t, k)
    local _api
    if vim.api ~= nil and vim.api[k] ~= nil then
      _api = function(...)
        return vim.api[k](...)
      end
    else
      _api = function(...)
        return Vim.call(k, ...)
      end
    end
    t[k] = _api
    return _api
  end,
})

---The Vim standard library so to say, inherited from Vim, it contains everything Vim has.
---Ex-commands and vimscript-functions as well as user-functions in Vimscript.
---These are accessed through `vim.cmd()` and `vim.fn` respectively.
---https://neovim.io/doc/user/lua/#vim.fn
---
---Some links to docs to help me accesing them faster:
---@field fnamemodify function https://neovim.io/doc/user/vimfn/#fnamemodify()
---       Lua: Prefer vim.fs.dirname(), vim.fs.basename(), vim.fs.abspath(), and vim.fs.normalize() for common path	modifiers; modifier coverage differs.
Vim.fn = setmetatable({}, {
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
        return Vim.call(k, ...)
      end
    end
    t[k] = _fn
    return _fn
  end,
})

---https://neovim.io/doc/user/lua/#vim.fs
Vim.fs = setmetatable({}, {
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
---vim.v is an empty Lua table wrapper equipped with a metatable (__index and __newindex) that dynamically fetches variables from Neovim's internal C/Vimscript core on demand.
---Thats why we cannot treat it as usual Lua table and must call each variable explicitely.
---https://neovim.io/doc/user/vvars/
---
---@field argv table Command line arguments Nvim was invoked with. 
Vim.v = setmetatable({}, {
  __index = function(t, k)
    -- TODO: make it accessable like this!
    local success, value = pcall(vim.api.nvim_get_vvar, k)
    logger:debug('Read variable ' .. k .. ' with value ' .. value)
    if success then
      t[k] = value
    end

    -- if type(t[k]) == "function" then
      -- return function(first_arg, ...)
        -- if first_arg == t then
          -- return value(first_arg, ...)
        -- else
          -- return value(t, first_arg, ...)
        -- end
      -- end
    -- else
      -- return value
    -- end

    -- if vim.v ~= nil and vim.v[k] ~= nil then
      -- _v = vim.v.argv
    -- end
    -- t[k] = _v
    return value
  end,
})

---https://neovim.io/doc/user/lua/#vim.call()
---Equivalent to `vim.fn[func]({...})`
function Vim.call(func, ...)
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

function Vim.getchar(...)
  if vim.fn.empty(vim.g._spacevim_input_list) == 0 then
    local input_list = vim.g._spacevim_input_list
    local input_timeout = vim.g._spacevim_input_timeout or 0
    if input_timeout > 0 then
      vim.cmd('sleep ' .. input_timeout .. 'm')
    end
    local char = table.remove(input_list, 1)
    vim.g._spacevim_input_list = input_list
    return char

  end
  local status, ret = pcall(vim.fn.getchar, ...)
  if not status then
    ret = 3
  end
  if type(ret) == 'number' then
    return vim.fn.nr2char(ret)
  else
    return ret
  end
end

function Vim.setbufvar(buf, opts)
  
end

function Vim.getchar2nr(...)
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

function Vim.empty(expr)
  return vim.fn.empty(expr) == 1
end

function Vim.executable(bin)
  return vim.fn.executable(bin) == 1
end

function Vim.is_qf_win(winnr)
  
end

return Vim
