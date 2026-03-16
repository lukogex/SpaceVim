"=============================================================================
" vim.vim --- spacevim vim layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! spacevim#layers#vim#plugins() abort
    return [
            \ ['Shougo/vimshell.vim',                { 'on_cmd':['VimShell']}],
            \ ['mattn/vim-terminal',                 { 'on_cmd':['Terminal']}],
            \ ]
endfunction

function! spacevim#layers#vim#config() abort
  augroup spacevim_vim_layer
    autocmd!
    " @todo clear vim comment string highlight
    " autocmd Syntax vim syntax clear vimCommentString
  augroup END
endfunction

function! spacevim#layers#vim#health() abort
  call spacevim#layers#vim#plugins()
  call spacevim#layers#vim#config()
  return 1
endfunction

function! spacevim#layers#vim#loadable() abort

  return 1

endfunction
