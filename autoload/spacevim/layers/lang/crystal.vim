"=============================================================================
" crystal.vim --- spacevim lang#crystal layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#crystal, layers-lang-crystal
" @parentsection layers
" @subsection Intro
"
" The lang#crystal layer provides crystal filetype detection and syntax highlight,
" crystal tool and crystal spec integration. To enable this layer:
" >
"   [[layers]]
"     name = "lang#crystal"
" <
"
" @subsection mapping
" >
"   Key binding       description
"   SPC l r           run current code
"
" This layer also provides REPL support for crystal, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! spacevim#layers#lang#crystal#plugins() abort
  return [
      \ ['rhysd/vim-crystal', { 'on_ft' : 'crystal' }]
      \ ]
endfunction

function! spacevim#layers#lang#crystal#config() abort
  call spacevim#plugins#repl#reg('crystal', 'icr')
  call spacevim#plugins#runner#reg_runner('crystal', 'crystal run --no-color %s')
  call spacevim#mapping#space#regesit_lang_mappings('crystal', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nnoremap', ['l', 'r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("crystal")',
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

  if spacevim#layers#lsp#check_filetype('crystal')
    nnoremap <silent><buffer> K :call spacevim#lsp#show_doc()<CR>

    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call spacevim#lsp#show_doc()', 'show_document', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call spacevim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction


function! spacevim#layers#lang#crystal#health() abort
  call spacevim#layers#lang#crystal#plugins()
  call spacevim#layers#lang#crystal#config()
  return 1
endfunction
