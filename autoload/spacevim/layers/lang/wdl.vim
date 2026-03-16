"=============================================================================
" wdl.vim --- openwdl support in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#wdl, layers-lang-wdl
" @parentsection layers
" This layer provides syntax highlighting for WDL file. and it is disabled by
" default, to enable this layer, add following snippet to your spacevim
" configuration file.
" >
"   [[layers]]
"     name = 'lang#wdl'
" <
"

function! spacevim#layers#lang#wdl#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-wdl', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#wdl#health() abort
  call spacevim#layers#lang#wdl#plugins()
  return 1
endfunction
