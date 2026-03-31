"=============================================================================
" prolog.vim --- prolog support in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#prolog, layers-lang-prolog
" @parentsection layers
" This layer is for prolog development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#prolog'
" <
"
" @subsection Key bindings
"
" >
"   Key             Function
"   --------------------------------
"   SPC l r         run current file
" <
"
" The default code runner command is `swipl -q -f %s -t main`, `%s` will be
" replaced to the path of current file.
"
" This layer also provides REPL support for prolog, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! spacevim#layers#lang#prolog#plugins() abort
  let plugins = []
  " @todo Use new prolog plugin
  " call add(plugins, ['wsdjeg/prolog-vim', { 'merged' : 0}])
  call add(plugins, ['wsdjeg/prolog.vim', { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#prolog#config() abort
  call spacevim#plugins#repl#reg('prolog', 'swipl -q')
  call spacevim#plugins#runner#reg_runner('prolog', 'swipl -q -f %s -t main')
  call spacevim#mapping#space#regesit_lang_mappings('prolog', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("prolog")',
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

function! spacevim#layers#lang#prolog#health() abort
  call spacevim#layers#lang#prolog#plugins()
  call spacevim#layers#lang#prolog#config()
  return 1
endfunction
