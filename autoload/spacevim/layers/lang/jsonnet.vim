"=============================================================================
" jsonnet.vim --- jsonnet support for vim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#jsonnet, layers-lang-jsonnet
" @parentsection layers
" This layer adds syntax highlighting for the jsonnet Language.
" It is disabled by default, to enable this layer, add following snippet to your
" spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#jsonnet'
" <
"

function! spacevim#layers#lang#jsonnet#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-jsonnet', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#jsonnet#health() abort
  call spacevim#layers#lang#jsonnet#plugins()
  return 1
endfunction
