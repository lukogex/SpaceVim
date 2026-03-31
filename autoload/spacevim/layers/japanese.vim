"=============================================================================
" japanese.vim --- spacevim japanese layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! spacevim#layers#japanese#plugins() abort
    return [
          \ ['vim-jp/vimdoc-ja', {'merged' : 0}],
          \ ]
endfunction

function! spacevim#layers#japanese#config() abort
endfunction

function! spacevim#layers#japanese#health() abort
  call spacevim#layers#japanese#plugins()
  call spacevim#layers#japanese#config()
  return 1
endfunction
