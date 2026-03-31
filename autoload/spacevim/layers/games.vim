"=============================================================================
" games.vim --- spacevim games layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! spacevim#layers#games#plugins() abort
    let plugins = []
    call add(plugins, ['wsdjeg/vim2048', {'merged' : 0}])
    return plugins
endfunction

function! spacevim#layers#games#config() abort
    let g:_spacevim_mappings_space.g = {'name' : '+Games'}
    call spacevim#mapping#space#def('nnoremap', ['g', '2'], 'call vim2048#start()', '2048-in-vim', 1)
endfunction

function! spacevim#layers#games#health() abort
  call spacevim#layers#games#plugins()
  call spacevim#layers#games#config()
  return 1
endfunction
