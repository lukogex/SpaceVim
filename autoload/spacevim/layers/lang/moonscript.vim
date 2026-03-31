"=============================================================================
" moonscript.vim --- moonscript support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#moonscript, layers-lang-moonscript
" @parentsection layers
" This layer is for moonscript development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#moonscript'
" <
"
" @subsection Key bindings
" >
"   Key             Function
"   -----------------------------
"   SPC l r         Run current moonscript
" <
"
" This layer also provides REPL support for moonscript, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"


function! spacevim#layers#lang#moonscript#plugins() abort
  let plugins = []
  call add(plugins, ['leafo/moonscript-vim', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#moonscript#config() abort
  call spacevim#plugins#repl#reg('moon', 'mooni')
  call spacevim#plugins#runner#reg_runner('moon', 'moon %s')
  call spacevim#mapping#space#regesit_lang_mappings('moon', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("moonscript")',
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

function! spacevim#layers#lang#moonscript#health() abort
  call spacevim#layers#lang#moonscript#plugins()
  call spacevim#layers#lang#moonscript#config()
  return 1
endfunction
