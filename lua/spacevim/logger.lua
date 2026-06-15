--=============================================================================
-- logger.lua --- logger implemented in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local M = {}

local svim_logger = require("spacevim.api.logger"):new({ level = "debug", name = "spacevim" })
local cmd = require('spacevim.api.vim.compatible').cmd
local call = require('spacevim.api.vim.compatible').call
local echo = require('spacevim.api.vim.compatible').echo

function M.info(msg)
  svim_logger:info(msg)
end

function M.warn(msg, ...)
  svim_logger:warn(msg, ...)
end

function M.error(msg)
  svim_logger:error(msg)
end

function M.debug(msg)
  svim_logger:debug(msg)
end

function M.setLevel(level)
  svim_logger:set_level(level)
end

function M.setOutput(file)
  svim_logger:set_file(file)
end

function M.viewRuntimeLog()
  cmd('tabnew')
  cmd('setl nobuflisted')
  cmd('nnoremap <buffer><silent> q :tabclose!<CR>')
  -- Put info into buffer
  vim.fn.append(0, svim_logger:view_all())
  cmd('setl nomodifiable')
  cmd('setl buftype=nofile')
  cmd('setl filetype=spacevimLog')
  -- M.syntax_extra()
end

function M.clearRuntimeLog()
  svim_logger:clear()
end

function M.viewLog(...)
  local argvs = { ... }
  local info = '<details><summary> spacevim debug information </summary>\n\n'
    .. '### spacevim options :\n\n'
    .. '```toml\n'
    .. vim.fn.join(call('spacevim#options#list'), '\n')
    .. '\n```\n'
    .. '\n\n'
    .. '### spacevim layers :\n\n'
    .. call('spacevim#layers#report')
    .. '\n\n'
    .. '### spacevim Health checking :\n\n'
    .. call('spacevim#health#report')
    .. '\n\n'
    .. '### spacevim runtime log :\n\n'
    .. '```log\n'
    .. svim_logger:view_all()
    .. '\n```\n</details>\n\n'
  if argvs ~= nil and #argvs >= 1 then
    local bang = argvs[1]
    if bang == 1 then
      cmd('tabnew')
      cmd('setl nobuflisted')
      cmd('nnoremap <buffer><silent> q :tabclose!<CR>')
      -- put info into buffer
      vim.fn.append(0, vim.fn.split(info, '\n'))
      cmd('setl nomodifiable')
      cmd('setl buftype=nofile')
      cmd('setl filetype=markdown')
    else
      echo(info)
    end
  else
    return info
  end
end

function M.syntax_extra()
  vim.fn.matchadd('ErrorMsg', '.*[\\sError\\s\\].*')
  vim.fn.matchadd('WarningMsg', '.*[\\sWarn\\s\\].*')
end

---TODO: Derive should be replaced by own logger instance!
function M.derive(name)
  local derive = {
    origin_name = svim_logger.get_name(),
    _debug_mode = true,
    derive_name = vim.fn.printf('%' .. vim.fn.strdisplaywidth(svim_logger.get_name()) .. 'S', name),
  }

  function derive.info(msg)
    svim_logger.set_name(derive.derive_name)
    svim_logger.info(msg)
    svim_logger.set_name(derive.origin_name)
  end
  function derive.warn(msg)
    svim_logger.set_name(derive.derive_name)
    svim_logger.warn(msg)
    svim_logger.set_name(derive.origin_name)
  end
  function derive.error(msg)
    svim_logger.set_name(derive.derive_name)
    svim_logger.error(msg)
    svim_logger.set_name(derive.origin_name)
  end

  function derive.debug(msg)
    if derive._debug_mode then
      svim_logger.set_name(derive.derive_name)
      svim_logger.debug(msg)
      svim_logger.set_name(derive.origin_name)
    end
  end
  function derive.start_debug()
    derive._debug_mode = true
  end
  function derive.stop_debug()
    derive._debug_mode = false
  end
  function derive.debug_enabled() -- {{{
    return derive._debug_mode
  end
  -- }}}
  return derive
end

return M
