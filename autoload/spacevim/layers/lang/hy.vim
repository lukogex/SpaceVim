"=============================================================================
" hy.vim --- hy language support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#hy, layers-lang-hy
" @parentsection layers
" This layer is for hy development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#hy'
" <
"
" @subsection layer options
"
" 1. `hy_interpreter`: Set the hy interpreter, by default, it is `hy`
" >
"   [[layers]]
"     name = 'lang#hy'
"     hy_interpreter = 'path/to/hy'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for hy, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

if exists('s:hy_interpreter')
  finish
endif

let s:hy_interpreter = 'hy'

function! spacevim#layers#lang#hy#plugins() abort
  let plugins = []
  call add(plugins, ['hylang/vim-hy', { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#hy#config() abort
  call spacevim#plugins#repl#reg('hy', s:hy_interpreter)
  call spacevim#plugins#runner#reg_runner('hy', s:hy_interpreter . ' %s')
  call spacevim#mapping#space#regesit_lang_mappings('hy', function('s:language_specified_mappings'))
endfunction

function! spacevim#layers#lang#hy#set_variable(var) abort
  let s:hy_interpreter = get(a:var, 'hy_interpreter', s:hy_interpreter)
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("hy")',
        \ 'start REPL process', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call spacevim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call spacevim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call spacevim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
endfunction

function! spacevim#layers#lang#hy#health() abort
  call spacevim#layers#lang#hy#plugins()
  call spacevim#layers#lang#hy#config()
  return 1
endfunction
