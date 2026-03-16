"=============================================================================
" cmake.vim --- spacevim cmake layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#cmake, layers-lang-cmake
" @parentsection layers
" This layer is for cmake development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#cmake'
" <
"

function! spacevim#layers#lang#cmake#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-cmake-syntax',        { 'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-cmake',        { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#cmake#config() abort
  call spacevim#mapping#space#regesit_lang_mappings('cmake',
        \ function('s:on_ft'))
  if spacevim#layers#lsp#check_filetype('cmake')
        \ || spacevim#layers#lsp#check_server('cmake')
    call spacevim#mapping#gd#add('cmake',
          \ function('spacevim#lsp#go_to_def'))
    call spacevim#mapping#g_capital_d#add('cmake',
          \ function('spacevim#lsp#go_to_declaration'))
  endif
endfunction
function! s:on_ft() abort
  if spacevim#layers#lsp#check_filetype('cmake')
        \ || spacevim#layers#lsp#check_server('cmake')
    nnoremap <silent><buffer> K :call spacevim#lsp#show_doc()<CR>

    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call spacevim#lsp#show_doc()', 'show-document', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call spacevim#lsp#references()', 'show-references', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call spacevim#lsp#rename()', 'rename-symbol', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'h'],
          \ 'call spacevim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)
    let g:_spacevim_mappings_space.l.w = {'name' : '+Workspace'}
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'w', 'l'],
          \ 'call spacevim#lsp#list_workspace_folder()', 'list-workspace-folder', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'w', 'a'],
          \ 'call spacevim#lsp#add_workspace_folder()', 'add-workspace-folder', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'w', 'r'],
          \ 'call spacevim#lsp#remove_workspace_folder()', 'remove-workspace-folder', 1)
  endif
endfunction

function! spacevim#layers#lang#cmake#health() abort
  call spacevim#layers#lang#cmake#config()
  call spacevim#layers#lang#cmake#plugins()
  return 1

endfunction
