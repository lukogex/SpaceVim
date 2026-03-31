"=============================================================================
" erlang.vim --- erlang support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#erlang, layers-lang-erlang
" @parentsection layers
" This layer is for erlang development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#erlang'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for erlang, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

let s:is_erlang = spacevim#layers#lsp#check_filetype('erlang')
      \ || spacevim#layers#lsp#check_server('erlang_ls')


function! spacevim#layers#lang#erlang#plugins() abort
  let plugins = []
  call add(plugins, ['vim-erlang/vim-erlang-compiler', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-omnicomplete', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-runtime', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-tags', {'on_ft' : 'erlang'}])
  return plugins
endfunction


function! spacevim#layers#lang#erlang#config() abort
  call spacevim#plugins#repl#reg('erlang', 'erl')
  call spacevim#plugins#runner#reg_runner('erlang', ['erlc -o #TEMP# %s', 'erl -pa #TEMP#'])
  call spacevim#mapping#space#regesit_lang_mappings('erlang', function('s:language_specified_mappings'))
  call spacevim#mapping#gd#add('erlang', function('s:go_to_def'))

  if s:is_erlang
    call spacevim#mapping#gd#add('erlang', function('spacevim#lsp#go_to_def'))
  else
    call spacevim#mapping#gd#add('erlang', function('s:go_to_def'))
  endif
endfunction


function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nnoremap', ['l','r'],
        \ 'call spacevim#plugins#runner#open()',
        \ 'execute current file', 1)

  if s:is_erlang
    nnoremap <silent><buffer> K :call spacevim#lsp#show_doc()<CR>
    nnoremap <silent><buffer> gD :<C-u>call spacevim#lsp#go_to_typedef()<Cr>
  endif
"
  call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
        \ 'call spacevim#lsp#show_doc()', 'show-document', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l', 'x'],
        \ 'call spacevim#lsp#references()', 'show-references', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l', 'e'],
        \ 'call spacevim#lsp#rename()', 'rename-symbol', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l', 's'],
        \ 'call spacevim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)

  let g:_spacevim_mappings_space.l.w = {'name' : '+Workspace'}
  call spacevim#mapping#space#langSPC('nnoremap', ['l', 'w', 'l'],
        \ 'call spacevim#lsp#list_workspace_folder()', 'list-workspace-folder', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l', 'w', 'a'],
        \ 'call spacevim#lsp#add_workspace_folder()', 'add-workspace-folder', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l', 'w', 'r'],
        \ 'call spacevim#lsp#remove_workspace_folder()', 'remove-workspace-folder', 1)

  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}

  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("erlang")',
        \ 'start REPL process', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call spacevim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call spacevim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call spacevim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
endfunction


function! s:go_to_def() abort
  if s:is_erlang
    call spacevim#lsp#go_to_def()
  else
    normal! gd
  endif
endfunction


function! spacevim#layers#lang#erlang#health() abort
  call spacevim#layers#lang#erlang#plugins()
  call spacevim#layers#lang#erlang#config()
  return 1
endfunction
