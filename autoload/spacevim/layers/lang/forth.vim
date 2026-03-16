"=============================================================================
" forth.vim --- forth language support in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#forth, layers-lang-forth
" @parentsection layers
" This layer is for forth development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#forth'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"

function! spacevim#layers#lang#forth#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-forth', {'merged' : 0}])
  return plugins
endfunction


function! spacevim#layers#lang#forth#config() abort
  call spacevim#plugins#runner#reg_runner('forth', 'bigforth %s')
  call spacevim#mapping#space#regesit_lang_mappings('forth', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
endfunction

function! spacevim#layers#lang#forth#health() abort
  call spacevim#layers#lang#forth#plugins()
  call spacevim#layers#lang#forth#config()
  return 1
endfunction
