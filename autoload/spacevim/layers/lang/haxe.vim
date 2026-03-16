"=============================================================================
" haxe.vim --- haxe language support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#haxe, layers-lang-haxe
" @parentsection layers
" This layer is for haxe development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#haxe'
" <
"
" @subsection layer options
"
" 1. `haxe_interpreter`: Set the haxe interpreter, by default, it is `haxe`
" >
"   [[layers]]
"     name = 'lang#haxe'
"     haxe_interpreter = 'path/to/haxe'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for haxe, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

if exists('s:haxe_interpreter')
  finish
endif

let s:haxe_interpreter = 'haxe'
let s:haxe_repl = 'haxe-repl'

function! spacevim#layers#lang#haxe#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-haxe', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#haxe#config() abort
  call spacevim#plugins#repl#reg('haxe', s:haxe_repl)
  call spacevim#plugins#runner#reg_runner('haxe', s:haxe_interpreter . ' --main %s --interp')
  call spacevim#mapping#space#regesit_lang_mappings('haxe', function('s:language_specified_mappings'))
endfunction

function! spacevim#layers#lang#haxe#set_variable(var) abort
  let s:haxe_interpreter = get(a:var, 'haxe_interpreter', s:haxe_interpreter)
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("haxe")',
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

function! spacevim#layers#lang#haxe#health() abort
  call spacevim#layers#lang#haxe#plugins()
  call spacevim#layers#lang#haxe#config()
  return 1
endfunction
