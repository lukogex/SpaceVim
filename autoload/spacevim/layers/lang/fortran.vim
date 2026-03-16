"=============================================================================
" fortran.vim --- fortran language support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#fortran, layers-lang-fortran
" @parentsection layers
" This layer is for fortran development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#fortran'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for fortran, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! spacevim#layers#lang#fortran#plugins() abort
  let plugins = []
  call add(plugins,[g:_spacevim_root_dir . 'bundle/fortran.vim',        { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#fortran#config() abort
  call spacevim#plugins#runner#reg_runner('fortran', ['gfortran %s -o #TEMP#', '#TEMP#'])
  call spacevim#plugins#repl#reg('fortran', 'frepl')
  call spacevim#mapping#space#regesit_lang_mappings('fortran', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nnoremap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("fortran")',
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


" ref:
"
" fortran wiki org
"
" http://fortranwiki.org/fortran/show/Source+code+editors


function! spacevim#layers#lang#fortran#health() abort
  call spacevim#layers#lang#fortran#plugins()
  call spacevim#layers#lang#fortran#config()
  return 1
endfunction
