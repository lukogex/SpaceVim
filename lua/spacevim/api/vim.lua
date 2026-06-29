---This is an interface to the Nvim Lua standard library.
---Its purpose is to decouple Spacevim by preventing direct calls and to have a better overview about calls we do.
---Goal is to reduce dublication and have one common layer to interact with Neovim.
---Furthermore this might help in future compatibility implementations.
---TODO: Intergrate compatibility.lua here!
local Vim = {}

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
