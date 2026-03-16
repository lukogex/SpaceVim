"=============================================================================
" aspectj.vim --- aspectj language support in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#aspectj, layers-lang-aspectj
" @parentsection layers
" This layer provides syntax highlighting for aspectj. To enable this
" layer:
" >
"   [[layers]]
"     name = "lang#aspectj"
" <

function! spacevim#layers#lang#aspectj#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-aspectj', { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#aspectj#health() abort
  call spacevim#layers#lang#aspectj#plugins()
  return 1
endfunction
