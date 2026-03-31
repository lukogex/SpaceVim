"=============================================================================
" gosu.vim --- gosu language support
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#gosu, layers-lang-gosu
" @parentsection layers
" This layer is for gosu development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#gosu'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <


function! spacevim#layers#lang#gosu#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-gosu', { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#gosu#config() abort
  call spacevim#plugins#runner#reg_runner('gosu', 'gosu %s')
  call spacevim#mapping#space#regesit_lang_mappings('gosu', function('s:language_specified_mappings'))
  " @todo add repl support for gosu
  " gosu language do not support repl as I know, here is issue link:
  " https://github.com/gosu-lang/gosu-lang/issues/155
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
endfunction

function! spacevim#layers#lang#gosu#health() abort
  call spacevim#layers#lang#gosu#plugins()
  call spacevim#layers#lang#gosu#config()
  return 1
endfunction
