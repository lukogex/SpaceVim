"=============================================================================
" operator.vim --- spacevim operator layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section operator, layers-operator
" @parentsection layers
" With this layer, you can confirm that text is yanked correctly and see
" yanked text by highlighting.

function! spacevim#layers#operator#plugins() abort
    let plugins = []
    call add(plugins, ['kana/vim-operator-user', { 'merged' : 0 }])
    call add(plugins, ['haya14busa/vim-operator-flashy', { 'merged' : 0 }])
    return plugins
endfunction

function! spacevim#layers#operator#config() abort
    map y <Plug>(operator-flashy)
    nmap Y <Plug>(operator-flashy)$
endfunction

function! spacevim#layers#operator#health() abort
  call spacevim#layers#operator#plugins()
  call spacevim#layers#operator#config()
  return 1
endfunction
