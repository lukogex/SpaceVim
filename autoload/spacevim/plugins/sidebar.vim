"=============================================================================
" sidebar.vim --- sidebar manager for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" init option:
" width: sidebar_width
" direction: sidebar_direction


function! spacevim#plugins#sidebar#open(...) abort
  TagbarOpen
  wincmd p
  nnoremap <buffer><silent> q :call spacevim#plugins#sidebar#close()<cr>
  split
  wincmd p
  wincmd p
  VimFiler -no-split
  nnoremap <buffer><silent> q :call spacevim#plugins#sidebar#close()<cr>
endfunction


function! spacevim#plugins#sidebar#toggle() abort
  call spacevim#plugins#sidebar#open()
endfunction


function! spacevim#plugins#sidebar#close() abort
  TagbarClose
  VimFiler
endfunction
