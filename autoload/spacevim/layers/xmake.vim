"=============================================================================
" xmake.vim --- xmake support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section xmake, layers-xmake
" @parentsection layers
" The `xmake` layer provides basic function for xmake command.
" This layer is disabled by default, to use it:
" >
"   [[layers]]
"     name = 'xmake'
" <


function! spacevim#layers#xmake#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/xmake.vim', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#xmake#config() abort
  call add(g:spacevim_project_rooter_patterns, 'xmake.lua')
  let g:_spacevim_mappings_space.m.x = {'name' : '+xmake'}
  call spacevim#mapping#space#def('nnoremap', ['m', 'x', 'b'], 'call xmake#buildrun()', 'xmake-build-without-running', 1)
  call spacevim#mapping#space#def('nnoremap', ['m', 'x', 'r'], 'call xmake#buildrun(1)', 'xmake-build-amd-running', 1)
endfunction

function! spacevim#layers#xmake#health() abort
  call spacevim#layers#xmake#plugins()
  call spacevim#layers#xmake#config()
  return 1
endfunction
