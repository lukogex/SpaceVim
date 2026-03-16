"=============================================================================
" j.vim --- lang#j layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#j, layers-lang-j
" @parentsection layers
" This layer is for j development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#j'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for j, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! spacevim#layers#lang#j#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/j', { 'merged' : 0}])
  return plugins
endfunction


let s:jconsole_bin = 'jconsole'

function! spacevim#layers#lang#j#config() abort
  call spacevim#plugins#repl#reg('j', shellescape(s:jconsole_bin))
  call spacevim#plugins#runner#reg_runner('j', shellescape(s:jconsole_bin) . ' %s')
  call spacevim#mapping#space#regesit_lang_mappings('j', function('s:language_specified_mappings'))
endfunction


function! spacevim#layers#lang#j#set_variable(var) abort
  let s:jconsole_bin = get(a:var, 'jconsole-bin', s:jconsole_bin)
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','b'], 'call spacevim#api#import("job").start("jhs")', 'open browser IDE', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("j")',
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

function! spacevim#layers#lang#j#health() abort
  call spacevim#layers#lang#j#plugins()
  call spacevim#layers#lang#j#config()
  return 1
endfunction
