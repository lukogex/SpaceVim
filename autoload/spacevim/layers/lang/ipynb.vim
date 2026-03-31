"=============================================================================
" ipynb.vim --- spacevim lang#ipynb layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! spacevim#layers#lang#ipynb#plugins() abort
  let plugins = []
  " TODO: use remote plugin https://github.com/szymonmaszke/vimpyter
  call add(plugins, ['wsdjeg/vimpyter', {'merged' : 0}])
  return plugins
endfunction


function! spacevim#layers#lang#ipynb#config() abort
  call spacevim#mapping#space#regesit_lang_mappings('ipynb', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','p'],
        \ 'VimpyterInsertPythonBlock',
        \ 'insert python block', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','u'],
        \ 'VimpyterUpdate',
        \ 'update note book', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','j'],
        \ 'VimpyterStartJupyter',
        \ 'start jupyter', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','n'],
        \ 'VimpyterStartNteract',
        \ 'start nteract', 1)
endfunction

function! spacevim#layers#lang#ipynb#health() abort
  call spacevim#layers#lang#ipynb#plugins()
  call spacevim#layers#lang#ipynb#config()
  return 1
endfunction
