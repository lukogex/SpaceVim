"=============================================================================
" foxpro.vim --- Visual FoxPro language support
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#foxpro, layers-lang-foxpro
" @parentsection layers
" @subsection Intro
"
" The lang#foxpro layer provides syntax highlighting for foxpro.

function! spacevim#layers#lang#foxpro#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-foxpro', { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#foxpro#config() abort
  
endfunction

function! spacevim#layers#lang#foxpro#health() abort
  call spacevim#layers#lang#foxpro#plugins()
  call spacevim#layers#lang#foxpro#config()
  return 1
endfunction
