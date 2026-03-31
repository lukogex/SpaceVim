"=============================================================================
" swig.vim --- spacevim lang#swig layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#swig, layers-lang-swig
" @parentsection layers
" This layer is for swig development, including syntax highlighting and
" indent. To enable it:
" >
"   [[layers]]
"     name = "lang#swig"
" <

function! spacevim#layers#lang#swig#plugins() abort
    let plugins = []
    call add(plugins, ['spacevim/vim-swig'])
    return plugins
endfunction

function! spacevim#layers#lang#swig#config() abort
    
endfunction

function! spacevim#layers#lang#swig#health() abort
  call spacevim#layers#lang#swig#plugins()
  call spacevim#layers#lang#swig#config()
  return 1
endfunction
