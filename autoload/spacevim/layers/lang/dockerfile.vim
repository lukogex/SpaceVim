"=============================================================================
" dockerfile.vim --- layer for editing Dockerfile
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#dockerfile, layers-lang-dockerfile
" @parentsection layers
" @subsection Intro
"
" The lang#dockerfile layer provides syntax highlighting for dockerfile.
" By default it is disabled, to enable this layer:
" >
"   [[layers]]
"     name = "lang#dockerfile"
" <

function! spacevim#layers#lang#dockerfile#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-dockerfile', {'merged' : 0}])
  return plugins
endfunction


function! spacevim#layers#lang#dockerfile#config() abort

  call spacevim#mapping#space#regesit_lang_mappings('dockerfile', function('s:language_specified_mappings'))

endfunction

function! s:language_specified_mappings() abort
  if spacevim#layers#lsp#check_filetype('dockerfile')
    nnoremap <silent><buffer> K :call spacevim#lsp#show_doc()<CR>

    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call spacevim#lsp#show_doc()', 'show_document', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call spacevim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction

function! spacevim#layers#lang#dockerfile#health() abort
  call spacevim#layers#lang#dockerfile#plugins()
  call spacevim#layers#lang#dockerfile#config()
  return 1
endfunction
