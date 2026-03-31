"=============================================================================
" vue.vim --- lang#vue layer for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section lang#vue, layers-lang-vue
" @parentsection layers
" This layer is for vue development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#vue'
" <
"
" The `checkers` layer provides syntax linter for vue. you need to install the
" `eslint` and `eslint-plugin-vue`:
" >
"   npm install -g eslint eslint-plugin-vue
" <

function! spacevim#layers#lang#vue#plugins() abort
  let plugins = []
  call add(plugins, ['posva/vim-vue', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#vue#health() abort
  call spacevim#layers#lang#vue#plugins()
  return 1
endfunction
