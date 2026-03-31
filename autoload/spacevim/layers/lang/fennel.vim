"=============================================================================
" fennel.vim --- fennel language support
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:fennel_interpreter')
  finish
endif

""
" @section lang#fennel, layers-lang-fennel
" @parentsection layers
" This layer is for fennel development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#fennel'
" <
"
" @subsection layer options
"
" 1. `fennel_interpreter`: Set the path of `fennel` command,
" by default it is `fennel`.
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for fennel, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

let s:fennel_interpreter = 'fennel'

function! spacevim#layers#lang#fennel#plugins() abort

  let plugins = []
  call add(plugins, ['bakpakin/fennel.vim', {'merged' : 0}])
  return plugins


endfunction

function! spacevim#layers#lang#fennel#config() abort


  call spacevim#plugins#repl#reg('fennel', s:fennel_interpreter)
  call spacevim#plugins#runner#reg_runner('fennel', s:fennel_interpreter . ' %s')
  call spacevim#mapping#space#regesit_lang_mappings('fennel', function('s:language_specified_mappings'))

endfunction

function! spacevim#layers#lang#fennel#set_variable(var) abort
  let s:fennel_interpreter = get(a:var, 'fennel_interpreter', s:fennel_interpreter)
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("fennel")',
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

function! spacevim#layers#lang#fennel#health() abort
  call spacevim#layers#lang#fennel#plugins()
  call spacevim#layers#lang#fennel#config()
  return 1
endfunction
