"=============================================================================
" ruby.vim --- lang#ruby layer for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#ruby, layers-lang-ruby
" @parentsection layers
" This layer is for ruby development, disabled by default, to enable this
" layer, add following snippet to your @section(options) file.
" >
"   [[layers]]
"     name = 'lang#ruby'
" <
"
" @subsection Options
"
" 1. ruby_file_head: the default file head for ruby source code.
" >
"   [[layers]]
"     name = "lang#ruby"
"     ruby_file_head = [      
"       '#!/usr/bin/ruby -w',
"       '# -*- coding : utf-8 -*-'
"       ''
"     ]
" <
" 2. repl_command: the REPL command for ruby
" >
"   [[layers]]
"     name = 'lang#ruby'
"     repl_command = '~/download/bin/ruby_repl'
" <
" 3. format_on_save: enable/disable code formation when save ruby file. This
" options is disabled by default, to enable it:
" >
"   [[layers]]
"     name = 'lang#ruby'
"     repl_command = '~/download/bin/ruby_repl'
"     format_on_save = true
" <
" @subsection Key bindings
"
" >
"   Key             Function
"   --------------------------------
"   SPC l r         run current file
" <
"
" This layer also provides REPL support for ruby, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
" To enable lsp support for ruby, you need to instal solargraph.
" >
"   gem install --user-install solargraph
" <
" Enable the lsp layer for ruby:
" >
"   [[layers]]
"     name = 'lsp'
"     enabled_clients = ['solargraph']
" <
" If the lsp layer is enabled for ruby, the following key bindings can
" be used:
" >
"   key binding     Description
"   g D             jump to type definition
"   SPC l e         rename symbol
"   SPC l x         show references
"   SPC l h         show line diagnostics
"   SPC l d         show document
"   K               show document
"   SPC l w l       list workspace folder
"   SPC l w a       add workspace folder
"   SPC l w r       remove workspace folder
" <


if exists('s:ruby_file_head')
  finish
else
  let s:ruby_repl_command = ''
  let s:ruby_file_head = [
        \ '#!/usr/bin/ruby -w',
        \ '# -*- coding : utf-8 -*-',
        \ ''
        \ ]
  let s:format_on_save = 0
  let s:lint_on_save = 0
  let s:enabled_linters = ['rubylint']
endif

function! spacevim#layers#lang#ruby#plugins() abort
  return [
        \ [g:_spacevim_root_dir . 'bundle/vim-ruby', {'merged' : 0, 'on_ft' : ['ruby']}]
        \ ]
endfunction


function! spacevim#layers#lang#ruby#config() abort
  call spacevim#plugins#runner#reg_runner('ruby', {
        \ 'exe' : 'ruby',
        \ 'opt' : ['-'],
        \ 'usestdin' : 1,
        \ })
  call spacevim#mapping#gd#add('ruby', function('s:go_to_def'))
  call spacevim#mapping#space#regesit_lang_mappings('ruby', function('s:language_specified_mappings'))
  if !empty(s:ruby_repl_command)
    call spacevim#plugins#repl#reg('ruby',s:ruby_repl_command)
  else
    call spacevim#plugins#repl#reg('ruby', 'irb')
  endif
  if g:spacevim_lint_engine ==# 'neomake'
    let g:neomake_ruby_enabled_makers = s:enabled_linters
    for lint in g:neomake_ruby_enabled_makers
      let g:neomake_ruby_{lint}_remove_invalid_entries = 1
    endfor
  endif
  " Format on save
  if s:format_on_save
    call spacevim#layers#format#add_filetype({
          \ 'filetype' : 'ruby',
          \ 'enable' : 1,
          \ })
  endif
endfunction

function! spacevim#layers#lang#ruby#set_variable(var) abort
  let s:ruby_repl_command = get(a:var, 'repl_command', '') 
  " add backward compatible for ruby-file-head
  let s:ruby_file_head = get(a:var,
        \ 'ruby_file_head',
        \ get(a:var,
        \ 'ruby-file-head',
        \ s:ruby_file_head))
  let s:format_on_save = get(a:var, 'format_on_save', s:format_on_save)
  let s:lint_on_save = get(a:var, 'lint_on_save', s:lint_on_save)
  let s:enabled_linters = get(a:var, 'enabled_linters', s:enabled_linters)
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l', 'r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  if spacevim#layers#lsp#check_filetype('ruby')
        \ || spacevim#layers#lsp#check_server('solargraph')
    nnoremap <silent><buffer> K :call spacevim#lsp#show_doc()<CR>
    nnoremap <silent><buffer> gD :<C-u>call spacevim#lsp#go_to_typedef()<Cr>

    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call spacevim#lsp#show_doc()', 'show-document', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call spacevim#lsp#references()', 'show-references', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call spacevim#lsp#rename()', 'rename-symbol', 1)
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
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("ruby")',
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
  if !spacevim#layers#lsp#check_filetype('ruby')
        \ && !spacevim#layers#lsp#check_server('solargraph')
    normal! gd
  else
    call spacevim#lsp#go_to_def()
  endif
endfunction

function! spacevim#layers#lang#ruby#get_options() abort
  return [
        \ 'repl_command',
        \ 'ruby_file_head'
        \ ]
endfunction

function! spacevim#layers#lang#ruby#health() abort
  call spacevim#layers#lang#ruby#plugins()
  call spacevim#layers#lang#ruby#config()
  return 1
endfunction
