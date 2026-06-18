"=============================================================================
" log.vim --- logger for tagbar
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================

if exists('s:debug_enabled')
  finish
endif

let s:LOGGER = spacevim#logger#derive('tagbar')

function! tagbar#log#debug(msg) abort
  call s:LOGGER.debug(a:msg)
endfunction

function! tagbar#log#info(msg) abort
  call s:LOGGER.info(a:msg)
endfunction

function! tagbar#log#warn(msg) abort
  call s:LOGGER.warn(a:msg)
endfunction

function! tagbar#log#debug_enabled() abort
  return s:LOGGER.get_level() == luaeval('vim.log.levels.DEBUG')
endfunction
