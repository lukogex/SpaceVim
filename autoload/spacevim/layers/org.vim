"=============================================================================
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! spacevim#layers#org#plugins() abort
  return spacevim#layers#lang#org#plugins()
endfunction

function! spacevim#layers#org#config() abort
  
endfunction

function! spacevim#layers#org#health() abort
  call spacevim#layers#org#plugins()
  call spacevim#layers#org#config()
  return 1
endfunction
