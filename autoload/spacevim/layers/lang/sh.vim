"=============================================================================
" sh.vim --- spacevim lang#sh layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#sh, layers-lang-sh
" @parentsection layers
" This layer is for shell script development, including bash, zsh and fish.
" This layer provides basic syntax highlighting and code completion , and it
" is disabled by default, to enable this
" layer, add following snippet to your @section(options) file.
" >
"   [[layers]]
"     name = 'lang#sh'
" <
"

function! spacevim#layers#lang#sh#plugins() abort
  let l:plugins = []
  call add(l:plugins, ['chrisbra/vim-zsh', { 'on_ft' : 'zsh' }])
  call add(l:plugins, ['dag/vim-fish', { 'merged' : 0 }])
  if get(g:, 'spacevim_enable_ycm') == 1
    call add(l:plugins, ['Valodim/vim-zsh-completion', { 'on_ft' : 'zsh' }])
  else
    call add(l:plugins, ['zchee/deoplete-zsh', { 'on_ft' : 'zsh' }])
  endif
  return l:plugins
endfunction

function! spacevim#layers#lang#sh#config() abort
  " chrisbra/vim-zsh {{{
  let g:zsh_fold_enable = 1
  " }}}

  call spacevim#layers#edit#add_ft_head_tamplate('sh', s:bash_file_head)
  call spacevim#layers#edit#add_ft_head_tamplate('zsh', [
        \ '#!/usr/bin/env zsh',
        \ '',
        \ ''
        \ ])
  call spacevim#layers#edit#add_ft_head_tamplate('fish', [
        \ '#!/usr/bin/env fish',
        \ '',
        \ ''
        \ ])
  augroup spacevim_layer_lang_sh
    autocmd!
    autocmd FileType sh setlocal omnifunc=spacevim#plugins#bashcomplete#omnicomplete
  augroup END
  call spacevim#mapping#gd#add('sh', function('s:go_to_def'))
  call spacevim#mapping#gd#add('zsh', function('s:go_to_def'))
  call spacevim#mapping#gd#add('fish', function('s:go_to_def'))
  call spacevim#mapping#space#regesit_lang_mappings('sh', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort
  if spacevim#layers#lsp#check_filetype('sh')
    nnoremap <silent><buffer> K :call spacevim#lsp#show_doc()<CR>

    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call spacevim#lsp#show_doc()', 'show_document', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call spacevim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction

function! s:go_to_def() abort
  if spacevim#layers#lsp#check_filetype(&filetype)
    call spacevim#lsp#go_to_def()
  endif
endfunction


let s:bash_file_head = ['#!/usr/bin/env bash',
      \ '',
      \ ''
      \ ]

function! spacevim#layers#lang#sh#set_variable(var) abort
  let s:bash_file_head = get(a:var,
        \ 'bash_file_head',
        \ get(a:var,
        \ 'bash-file-head',
        \ s:bash_file_head))
endfunction

function! spacevim#layers#lang#sh#health() abort
  call spacevim#layers#lang#sh#plugins()
  call spacevim#layers#lang#sh#config()
  return 1
endfunction

function! spacevim#layers#lang#sh#loadable() abort

  return 1

endfunction
