"=============================================================================
" toml.vim --- toml layer for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#toml, layers-lang-toml
" @parentsection layers
" This layer provides basic syntax highlighting for toml. To enable it:
" >
"   [[layers]]
"     name = "lang#toml"
" <

function! spacevim#layers#lang#toml#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-toml', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#toml#config() abort
  call spacevim#mapping#space#regesit_lang_mappings('toml', function('s:toml_lang_mappings'))
endfunction

function! s:toml_lang_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','j'], 'call toml#preview()', 'toml-to-json', 1)
endfunction

function! spacevim#layers#lang#toml#health() abort
  call spacevim#layers#lang#toml#plugins()
  return 1
endfunction

function! spacevim#layers#lang#toml#loadable() abort

  return 1

endfunction

function! spacevim#layers#lang#toml#set_variable(var) abort

  

endfunction
