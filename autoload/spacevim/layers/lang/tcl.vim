"=============================================================================
" tcl.vim --- tcl language support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section lang#tcl, layers-lang-tcl
" @parentsection layers
" This layer is for tcl development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#tcl'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for tcl, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! spacevim#layers#lang#tcl#plugins() abort
  let plugins = []
  
  return plugins
endfunction

function! spacevim#layers#lang#tcl#config() abort
  call spacevim#plugins#repl#reg('tcl', 'tclsh')
  call spacevim#plugins#runner#reg_runner('tcl', 'tclsh %s')
  call spacevim#mapping#space#regesit_lang_mappings('tcl', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("tcl")',
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

" Tcl 教程
" https://www.yiibai.com/tcl/tcl_basic_syntax.html
"
" 1. the default tcl shell command is tclsh


function! spacevim#layers#lang#tcl#health() abort
  call spacevim#layers#lang#tcl#plugins()
  call spacevim#layers#lang#tcl#config()
  return 1
endfunction
