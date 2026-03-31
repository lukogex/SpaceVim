"=============================================================================
" elixir.vim --- spacevim lang#elixir layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#elixir, layers-lang-elixir
" @parentsection layers
" This layer is for elixir development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#elixir'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
"   normal          g d             jump to definition
" <
"
" This layer also provides REPL support for d, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! spacevim#layers#lang#elixir#plugins() abort
  let plugins = []
  call add(plugins, ['elixir-editors/vim-elixir', {'on_ft' : ['elixir', 'eelixir']}])
  if !spacevim#layers#lsp#check_filetype('elixir')
    call add(plugins, ['slashmili/alchemist.vim', {'on_ft' : 'elixir'}])
  endif
  return plugins
endfunction


function! spacevim#layers#lang#elixir#config() abort
  call spacevim#plugins#runner#reg_runner('elixir', 'elixir %s')
  call spacevim#plugins#repl#reg('elixir', 'iex')
  call spacevim#mapping#space#regesit_lang_mappings('elixir', function('s:language_specified_mappings'))
  call spacevim#mapping#gd#add('elixir', function('s:go_to_def'))
  let g:alchemist_mappings_disable = 1
  let g:alchemist_tag_disable = 1
endfunction
function! s:language_specified_mappings() abort
  if spacevim#layers#lsp#check_filetype('elixir')
    nnoremap <silent><buffer> K :call spacevim#lsp#show_doc()<CR>

    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call spacevim#lsp#show_doc()', 'show_document', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call spacevim#lsp#rename()', 'rename symbol', 1)
  else
    nnoremap <silent><buffer> K :call alchemist#exdoc()<CR>
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call alchemist#exdoc()', 'show_document', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 't'],
          \ 'call alchemist#jump_tag_stack()', 'jump to tag stack', 1)
  endif
  call spacevim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("elixir")',
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

function! s:go_to_def() abort
  if spacevim#layers#lsp#check_filetype('elixir')
    call spacevim#lsp#go_to_def()
  else
    ExDef
  endif
endfunction




function! spacevim#layers#lang#elixir#health() abort
  call spacevim#layers#lang#elixir#plugins()
  call spacevim#layers#lang#elixir#config()
  return 1
endfunction

" vim:set et sw=2 cc=80:
