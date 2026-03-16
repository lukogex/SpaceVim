"=============================================================================
" matlab.vim --- matlab support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! spacevim#layers#lang#matlab#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/matlab.vim', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#matlab#health() abort
  call spacevim#layers#lang#matlab#plugins()
  return 1
endfunction
