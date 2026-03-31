"=============================================================================
" yang.vim --- yang support for vim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#yang, layers-lang-yang
" @parentsection layers
" This layer adds syntax highlighting for the YANG data file.
" It is disabled by default, to enable this layer, add following snippet to your
" spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#yang'
" <
"

function! spacevim#layers#lang#yang#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/yang.vim', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#yang#health() abort
  call spacevim#layers#lang#yang#plugins()
  return 1
endfunction
