"=============================================================================
" e.vim --- E language layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#e, layers-lang-e
" @parentsection layers
" @subsection Intro
"
" This layer includes utilities and language-specific mappings for e development.
" By default it is disabled, to enable this layer:
" >
"   [[layers]]
"     name = "lang#e"
" <

if exists('s:e_interpreter')
  finish
endif

let s:e_interpreter = 'rune'
let s:e_jar_path = 'e.jar'

function! spacevim#layers#lang#e#plugins() abort
  let plugins = []
    call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-elang', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#e#config() abort
  call spacevim#plugins#repl#reg('e', shellescape(s:e_interpreter))
  call spacevim#plugins#runner#reg_runner('e', 'java -jar ' . shellescape(s:e_jar_path) .  ' --rune %s')
  call spacevim#mapping#space#regesit_lang_mappings('e', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("e")',
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

function! spacevim#layers#lang#e#set_variable(var) abort
  let s:e_interpreter = get(a:var, 'e_interpreter', s:e_interpreter)
  let s:e_jar_path = get(a:var, 'e_jar_path', s:e_jar_path)
endfunction

function! spacevim#layers#lang#e#get_options() abort

  return ['e_interpreter']

endfunction

function! spacevim#layers#lang#e#health() abort
  call spacevim#layers#lang#e#plugins()
  call spacevim#layers#lang#e#config()
  return 1
endfunction
