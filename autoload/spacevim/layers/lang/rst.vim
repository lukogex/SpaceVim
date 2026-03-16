"=============================================================================
" rst.vim --- rst language layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! spacevim#layers#lang#rst#plugins() abort
  let plugins = []
  " this is forked repo, 
  " @todo push to upstream
  call add(plugins, ['wsdjeg/riv.vim', {'merged' : 0}])
  return plugins
endfunction


function! spacevim#layers#lang#rst#config() abort
  
endfunction

function! spacevim#layers#lang#rst#health() abort
  call spacevim#layers#lang#rst#plugins()
  call spacevim#layers#lang#rst#config()
  return 1
endfunction
