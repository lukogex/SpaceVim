"=============================================================================
" splus.vim --- S-Plus language layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! spacevim#layers#lang#splus#plugins() abort
  let plugins = []
  
  return plugins
endfunction


function! spacevim#layers#lang#splus#config() abort
  
endfunction

function! spacevim#layers#lang#splus#health() abort
  call spacevim#layers#lang#splus#plugins()
  call spacevim#layers#lang#splus#config()
  return 1
endfunction
