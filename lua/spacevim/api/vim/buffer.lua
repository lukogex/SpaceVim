--=============================================================================
-- buffer.lua --- public buffer apis
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local Buffer = {}

---Creates a new, empty, unnamed buffer.
---https://neovim.io/doc/user/api/#nvim_create_buf()
---@param listed boolean Sets 'buflisted'.
---@param scratch boolean Creates a "throwaway" scratch-buffer for temporary work.
---@return buffer_id integer Buffer id, or 0 on error.
function Buffer.create(listed, scratch)
  return vim.api.nvim_create_buf(listed, scratch)
end

---@deprecated
function Buffer.create_buf(listed, scratch)
  return Buffer.create(listed, scratch)
end

---Find the corresponding buffer and if there is no such buffer, create one.
function Buffer.create_by_name(name, listed, scratch)
  local buffer_id = Buffer.find_by_name(name)
  if buffer_id == nil then
    buffer_id = Buffer.create(listed, scratch)
    vim.api.nvim_buf_set_name(buffer_id, name)
  end
  return buffer_id
end

---To get :bdelete behavior, reset 'buflisted' and pass unload=true.
---https://neovim.io/doc/user/api/#nvim_buf_delete()
function Buffer.delete(buffer_id)
  vim.bo.buflisted = false
  vim.api.nvim_buf_delete(buffer_id, { unload = true })
end

---@return buffer_id integer Deleted buffer id or nil if not found by name.
function Buffer.delete_by_name(buffer_name)
  local buffer_id = Buffer.find_by_name(buffer_name)
  if buffer_id == nil then
    return nil
  end
  Buffer.delete(buffer_id)
  return buffer_id
end

---@param name string
function Buffer.find_by_name(name)
  local buffer_list = vim.api.nvim_list_bufs()
  for _, buffer_id in ipairs(buffer_list) do
    local buffer_name = vim.fn.bufname(buffer_id)
    if buffer_name == name then
      return buffer_id
    end
  end
  return nil
end

function Buffer.set_lines(bufnr, startindex, endindex, replacement)
  if startindex < 0 then
    startindex = #vim.buffer(bufnr) + 1 + startindex
  end
  if endindex < 0 then
    endindex = #vim.buffer(bufnr) + 1 + endindex
  end
  if #replacement == endindex - startindex then
    for i = startindex, endindex - 1, 1 do
      vim.buffer(bufnr)[i + 1] = replacement[i - startindex]
    end
  else
    if endindex < #vim.buffer(bufnr) then
      for i = endindex + 1, #vim.buffer(bufnr), 1 do
        replacement:add(vim.buffer(bufnr)[i])
      end
    end
    for i = startindex, #replacement + startindex - 1, 1 do
      if i + 1 > #vim.buffer(bufnr) then
        vim.buffer(bufnr):insert(replacement[i - startindex])
      else
        vim.buffer(bufnr)[i + 1] = replacement[i - startindex]
      end
    end
    for i = #replacement + startindex + 1, #vim.buffer(bufnr), 1 do
      vim.buffer(bufnr)[#replacement + startindex + 1] = nil
    end
  end
end

---Out-of-bounds indices are clamped to the nearest valid value, unless strict_indexing is set.
---https://neovim.io/doc/user/api/#nvim_buf_get_lines()
function Buffer.get_lines(buffer_id, start_index, end_index, strict_indexing)
  return vim.api.nvim_buf_get_lines(buffer_id, start_index, end_index, strict_indexing)
end

---@return lines string[] Array of lines or nil if not found by name.
function Buffer.get_lines_by_name(buffer_name)
  local buffer_id = Buffer.find_by_name(buffer_name)
  if buffer_id == nil then
    return nil
  end
  return Buffer.get_lines(buffer_id, 0, -1, true)
end

function Buffer.listed_buffers()
  return vim.fn.filter(vim.fn.range(1, vim.fn.bufnr('$')), 'buflisted(v:val)')
end

function Buffer.resize(size, ...)
  local arg = { ... }
  local cmd = arg[1] or 'vertical'
  vim.cmd(cmd .. ' resize ' .. size)
end

function Buffer.open_pos(cmd, filename, line, col)
  vim.cmd('silent ' .. cmd .. ' ' .. filename)
  vim.fn.cursor(line, col)
end

---@param bufnr number the buffer number
---@param opt string option name
---@param value any option value
function Buffer.set_option(bufnr, opt, value)
  if vim.api.nvim_set_option_value then
    return vim.api.nvim_set_option_value(opt, value, {
      buf = bufnr
    })
  end
  if vim.api.nvim_buf_set_option then
    return vim.api.nvim_buf_set_option(bufnr, opt, value)
  end
end

function Buffer.get_option(bufnr, name)
  if vim.api.nvim_get_option_value then
    return vim.api.nvim_get_option_value(name, { buf = bufnr })
  end
  if vim.api.nvim_buf_get_option then
    return vim.api.nvim_buf_get_option(bufnr, name)
  end
end

function Buffer.write_to_file(buffer_id, file_path)
  local lines = Buffer.get_lines(buffer_id, 0, -1, true)
  vim.fn.writefile(lines, file_path)
end

return Buffer
