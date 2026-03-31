"=============================================================================
" eiffel.vim --- Eiffel language layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#eiffel, layers-lang-eiffel
" @parentsection layers
" This layer is for lang#eiffel development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#eiffel'
" <
"
" @subsection Key bindings
" >
"   Key             Function
"   -----------------------------
"   SPC l c         run eclean          
" <
"

function! spacevim#layers#lang#eiffel#plugins() abort
  let plugins = []
  " the upstream repo eiffelhub/vim-eiffel has not been updated since 2016.
  call add(plugins, ['wsdjeg/vim-eiffel', { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#eiffel#config() abort
  call spacevim#mapping#space#regesit_lang_mappings('eiffel', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nnoremap', ['l','c'],
        \ 'call spacevim#plugins#runner#run_task({"command" : "eclean", "args" : ["."], "isBackground" : 1})',
        \ 'run-eclean', 1)
endfunction

function! spacevim#layers#lang#eiffel#health() abort
  call spacevim#layers#lang#eiffel#plugins()
  call spacevim#layers#lang#eiffel#config()
  return 1
endfunction
