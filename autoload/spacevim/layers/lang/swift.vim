"=============================================================================
" swift.vim --- swift layer for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#swift, layers-lang-swift
" @parentsection layers
" This layer is for swift development, including syntax highlighting and
" indent. To enable it:
" >
"   [[layers]]
"     name = "lang#swift"
" <
" @subsection Mappings
" >
"   Key         Function
"   -----------------------------------------------
"   SPC l k     jumping to placeholders
"   SPC l r     Run current file
" <
" This layer also provides REPL support for swift, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

func! spacevim#layers#lang#swift#plugins() abort
  let plugins = []
  call add(plugins, ['keith/swift.vim', {'merged' : 0}])
  call add(plugins, ['mitsuse/autocomplete-swift', {'merged' : 0}])
  return plugins
endf


function! spacevim#layers#lang#swift#config() abort
  call spacevim#plugins#repl#reg('swift', 'swift')
  call spacevim#plugins#runner#reg_runner('swift', 'swift %s')
  call spacevim#mapping#space#regesit_lang_mappings('swift', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','k'],
        \ '<Plug>(autocomplete_swift_jump_to_placeholder)',
        \ 'jumping to placeholders', 0)
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("swift")',
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
" 1. https://jblevins.org/log/swift
" 2. https://medium.com/@mahmudahsan/running-and-compiling-swift-code-in-terminal-237ee4087a9c


function! spacevim#layers#lang#swift#health() abort
  call spacevim#layers#lang#swift#plugins()
  call spacevim#layers#lang#swift#config()
  return 1
endfunction
