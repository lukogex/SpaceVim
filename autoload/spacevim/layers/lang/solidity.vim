"=============================================================================
" solidity.vim --- spacevim solidity layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! spacevim#layers#lang#solidity#plugins() abort
  let plugins = [
        \ ['tomlion/vim-solidity', {'merged' : 0, 'on_ft' : 'solidity'}]
        \ ]
  return plugins
endfunction

function! spacevim#layers#lang#solidity#config() abort
  
endfunction

function! spacevim#layers#lang#solidity#health() abort
  call spacevim#layers#lang#solidity#plugins()
  call spacevim#layers#lang#solidity#config()
  return 1
endfunction
