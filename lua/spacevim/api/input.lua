local Input = {}

local fn = require('spacevim.api.vim.adapter').fn

---https://neovim.io/doc/user/vimfn/#getchar()
function Input.getchar(...)
  if fn.empty(vim.g._spacevim_input_list) == 0 then
    local input_list = vim.g._spacevim_input_list
    local input_timeout = vim.g._spacevim_input_timeout or 0
    if input_timeout > 0 then
      vim.cmd('sleep ' .. input_timeout .. 'm')
    end
    local char = table.remove(input_list, 1)
    vim.g._spacevim_input_list = input_list
    return char
  end
  
  local status, ret = pcall(fn.getchar, ...)
  if not status then
    ret = 3
  end
  if type(ret) == 'number' then
    return fn.nr2char(ret)
  else
    return ret
  end
end

return Input
