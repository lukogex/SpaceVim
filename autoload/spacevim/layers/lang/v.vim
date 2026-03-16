"=============================================================================
" v.vim --- vlang language support in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#v, layers-lang-v
" @parentsection layers
" This layer is for v development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#v'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for v, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! spacevim#layers#lang#v#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/v-vim', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#v#config() abort
  call spacevim#plugins#repl#reg('vlang', 'vrepl')
  call spacevim#mapping#space#regesit_lang_mappings('vlang', function('s:language_specified_mappings'))
  call spacevim#plugins#runner#reg_runner('vlang', 'v run %s')
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("vlang")',
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

function! spacevim#layers#lang#v#health() abort
  call spacevim#layers#lang#v#plugins()
  call spacevim#layers#lang#v#config()
  return 1
endfunction
