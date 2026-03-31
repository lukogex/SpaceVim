"=============================================================================
" ring.vim --- ring language support in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#ring, layers-lang-ring
" @parentsection layers
" This layer is for ring development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#ring'
" <
"
" @subsection Options
"
" 1. ring_repl: Set the path of ring repl.
" >
"   [[layers]]
"     name = "lang#ring"
"     ring_repl = "/path/to/repl.ring"
" <
" @subsection Key bindings
"
" The code runner for ring is "ring %" % will be replaced to the path of
" current ring file.
" >
"   Key             Function
"   --------------------------------
"   SPC l r         run current file
" <
"
" This layer also provides REPL support for ring, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! spacevim#layers#lang#ring#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-ring', { 'merged' : 0}])
  return plugins
endfunction


let s:ring_repl = ''

function! spacevim#layers#lang#ring#config() abort
  call spacevim#plugins#repl#reg('ring', 'ring ' . shellescape(s:ring_repl))
  call spacevim#plugins#runner#reg_runner('ring', 'ring %s')
  call spacevim#mapping#space#regesit_lang_mappings('ring', function('s:language_specified_mappings'))
endfunction

function! spacevim#layers#lang#ring#set_variable(opt) abort
  let s:ring_repl = get(a:opt, 'ring_repl', s:ring_repl) 
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("ring")',
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

function! spacevim#layers#lang#ring#get_options() abort
  return ['ring_repl']
endfunction

function! spacevim#layers#lang#ring#health() abort
  call spacevim#layers#lang#ring#plugins()
  call spacevim#layers#lang#ring#config()
  return 1
endfunction
