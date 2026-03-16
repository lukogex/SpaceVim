"=============================================================================
" nix.vim --- nix language support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Ben Gamari <ben@smart-cactus.org>
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#nix, layers-lang-nix
" @parentsection layers
" @subsection Intro
" The lang#nix layer provides syntax highlighting and basic LSP support for
" the Nix expression language.

function! spacevim#layers#lang#nix#plugins() abort
  let plugins = []
  call add(plugins, ['LnL7/vim-nix', {'on_ft' : ['nix']}])
  return plugins
endfunction

function! spacevim#layers#lang#nix#config() abort
  call spacevim#mapping#space#regesit_lang_mappings('nix', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  if spacevim#layers#lsp#check_filetype('nix')
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'r'],
          \ 'call spacevim#lsp#rename()', 'rename', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 's'],
          \ 'call spacevim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call spacevim#lsp#go_to_def()', 'go-to-definition', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'n'],
         \ 'call spacevim#lsp#diagnostic_goto_next()', 'next-diagnostic', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'p'],
         \ 'call spacevim#lsp#diagnostic_goto_prev()', 'previous-diagnostic', 1)
 endif
endfunction

function! spacevim#layers#lang#nix#health() abort
  call spacevim#layers#lang#nix#plugins()
  call spacevim#layers#lang#nix#config()
  return 1
endfunction

