"=============================================================================
" jr.vim --- lang#jr layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#jr, layers-lang-jr
" @parentsection layers
" This layer adds syntax highlighting for the JR Concurrent Programming Language.
" JR is the implementation of the SR language for Java.
" It is disabled by default, to enable this layer, add following snippet to your
" spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#jr'
" <
"

function! spacevim#layers#lang#jr#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-jr', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#jr#config() abort
  
endfunction

function! spacevim#layers#lang#jr#health() abort
  call spacevim#layers#lang#jr#plugins()
  call spacevim#layers#lang#jr#config()
  return 1
endfunction
