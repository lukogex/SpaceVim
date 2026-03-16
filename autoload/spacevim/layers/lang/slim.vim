"=============================================================================
" slim.vim --- spacevim lang#slimlayer
" Copyright (c) 2016-2023 Wang Shidong & Contributors 
" Author: Keisuke Tsukamoto < keisuke.cs at gmail.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! spacevim#layers#lang#slim#plugins() abort
  let plugins = []
  call add(plugins, ['slim-template/vim-slim', {'on_ft' : ['slim']}])
  return plugins
endfunction

function! spacevim#layers#lang#slim#health() abort
  call spacevim#layers#lang#slim#plugins()
  return 1
endfunction
