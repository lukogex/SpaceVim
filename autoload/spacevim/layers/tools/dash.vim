"=============================================================================
" dash.vim --- tools#dash layer file for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section tools#dash, layers-tools-dash
" @parentsection layers
" This layer provides Dash integration for spacevim

function! spacevim#layers#tools#dash#plugins() abort
  return [
        \ ['rizzatti/dash.vim', {
        \ 'on_map': { 'n': ['<Plug>DashSearch', '<Plug>DashGlobalSearch'] }
        \ }],
        \ ['rhysd/devdocs.vim', {
        \ 'on_map': { 'n': ['<Plug>(devdocs-under-cursor)'] }
        \ }],
        \ ]
endfunction

function! spacevim#layers#tools#dash#config() abort
  "" rizzatti/dash.vim {{{
  " Allows configuration of mappings between Vim filetypes and Dash's docsets.
  let g:dash_map = extend({
        \ 'java': ['java', 'android', 'javafx', 'spring', 'javadoc'],
        \ }, get(g:, 'dash_map', {}))
  "" }}}

  let g:_spacevim_mappings_space.D = { 'name' : '+Dash' }
  call spacevim#mapping#space#def('nmap', ['D', 'b'],
        \ '<Plug>(devdocs-under-cursor)', 'search word on devdocs.io', 0)
  call spacevim#mapping#space#def('nmap', ['D', 'd'],
        \ '<Plug>DashSearch', 'search word under cursor', 0)
  call spacevim#mapping#space#def('nmap', ['D', 'D'],
        \ '<Plug>DashGlobalSearch', 'search word under cursor in all docs', 0)
endfunction

function! spacevim#layers#tools#dash#health() abort
  call spacevim#layers#tools#dash#plugins()
  call spacevim#layers#tools#dash#config()
  return 1
endfunction
