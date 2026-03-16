"=============================================================================
" chapel.vim --- chapel language support
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#chapel, layers-lang-chapel
" @parentsection layers
" This layer is for chapel development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#chapel'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         compile and run current file
" <
"

function! spacevim#layers#lang#chapel#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-chapel', { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#chapel#config() abort
  call spacevim#plugins#runner#reg_runner('chapel', ['chpl -o #TEMP# %s', '#TEMP#'])
  call spacevim#mapping#space#regesit_lang_mappings('chapel', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
endfunction
function! spacevim#layers#lang#chapel#health() abort
  call spacevim#layers#lang#chapel#plugins()
  call spacevim#layers#lang#chapel#config()
  return 1
endfunction
