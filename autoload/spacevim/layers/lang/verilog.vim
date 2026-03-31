"=============================================================================
" verilog.vim --- Verilog/SystemVerilog support
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#verilog, layers-lang-verilog
" @parentsection layers
" This layer is for verilog development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#verilog'
" <

function! spacevim#layers#lang#verilog#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/verilog', {'merged' : 0}])
  return plugins
endfunction

" ref：
" https://zhuanlan.zhihu.com/p/95081329

function! spacevim#layers#lang#verilog#config() abort
  call spacevim#plugins#runner#reg_runner('verilog', ['iverilog -o #TEMP# %s', '#TEMP#'])
  call spacevim#mapping#space#regesit_lang_mappings('verilog', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort

  call spacevim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call spacevim#plugins#runner#open()',
        \ 'execute current file', 1)
  if spacevim#layers#lsp#check_filetype('verilog')
        " \ || spacevim#layers#lsp#check_server('clangd')
    nnoremap <silent><buffer> K :call spacevim#lsp#show_doc()<CR>

    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call spacevim#lsp#show_doc()', 'show_document', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call spacevim#lsp#rename()', 'rename symbol', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call spacevim#lsp#references()', 'show-references', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'i'],
          \ 'call spacevim#lsp#go_to_impl()', 'implementation', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'h'],
          \ 'call spacevim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)
    let g:_spacevim_mappings_space.l.w = {'name' : '+Workspace'}
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'w', 'l'],
          \ 'call spacevim#lsp#list_workspace_folder()', 'list-workspace-folder', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'w', 'a'],
          \ 'call spacevim#lsp#add_workspace_folder()', 'add-workspace-folder', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'w', 'r'],
          \ 'call spacevim#lsp#remove_workspace_folder()', 'remove-workspace-folder', 1)

  endif
endfunction


function! spacevim#layers#lang#verilog#health() abort
  call spacevim#layers#lang#verilog#plugins()
  call spacevim#layers#lang#verilog#config()
  return 1
endfunction
