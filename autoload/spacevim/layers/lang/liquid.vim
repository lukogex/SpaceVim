"=============================================================================
" liquid.vim --- Liquid template language support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#liquid, layers-lang-liquid
" @parentsection layers
" This layer provides syntax highlighting for liquid. To enable this
" layer:
" >
"   [[layers]]
"     name = "lang#liquid"
" <

function! spacevim#layers#lang#liquid#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-liquid', { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#liquid#health() abort
  call spacevim#layers#lang#liquid#plugins()
  return 1
endfunction
