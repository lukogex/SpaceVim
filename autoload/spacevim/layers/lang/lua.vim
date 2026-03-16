"=============================================================================
" lua.vim --- spacevim lang#lua layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#lua, layers-lang-lua
" @parentsection layers
" This layer includes utilities and language-specific mappings for lua development.
" >
"   [[layers]]
"     name = 'lang#lua'
" <
"
" @subsection Layer options
"
" 1. lua_file_head: the default file head for lua source code.
" >
"   [[layers]]
"     name = "lang#lua"
"     ruby_file_head = [      
"       '--!/usr/bin/lua',
"       ''
"     ]
" <
" 2. repl_command: the REPL command for lua
" >
"   [[layers]]
"     name = 'lang#lua'
"     repl_command = '~/download/bin/lua'
" <
" 3. format_on_save: enable/disable code formation when save lua file. This
" options is disabled by default, to enable it:
" >
"   [[layers]]
"     name = 'lang#lua'
"     format_on_save = true
" <
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current script
"   normal          SPC l b         compile current file
" <
"
" This layer also provides REPL support for lua, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"


if exists('s:lua_repl_command')
  finish
endif

let s:lua_repl_command = ''
let s:lua_foldmethod = 'manual'
let s:lua_file_head = [
      \ '--!/usr/bin/lua',
      \ ''
      \ ]
let s:format_on_save = 0

function! spacevim#layers#lang#lua#plugins() abort
  let plugins = []
  " Improved Lua 5.3 syntax and indentation support for Vim
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-lua', {'on_ft' : 'lua'}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/neodev.nvim', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#lua#config() abort

  augroup spacevim_lang_lua
    autocmd!
    autocmd FileType lua set comments=f:--
    autocmd FileType lua let &l:foldmethod=s:lua_foldmethod
  augroup END
  call spacevim#mapping#space#regesit_lang_mappings('lua', function('s:language_specified_mappings'))
  let luaexe = filter(['lua53', 'lua52', 'lua51'], 'executable(v:val)')
  let exe_lua = empty(luaexe) ? 'lua' : luaexe[0]
  call spacevim#plugins#runner#reg_runner('lua', {
        \ 'exe' : exe_lua,
        \ 'opt' : ['-'],
        \ 'usestdin' : 1,
        \ })
  let g:neomake_lua_enabled_makers = ['luac']
  let luacexe = filter(['luac53', 'luac52', 'luac51'], 'executable(v:val)')
  let exe_luac = empty(luacexe) ? 'luac' : luacexe[0]
  let g:neomake_lua_luac_maker = {
        \ 'exe': exe_luac,
        \ 'args': ['-p'],
        \ 'errorformat': '%*\f: %#%f:%l: %m',
        \ }
  if !empty(s:lua_repl_command)
    let lua_repl = s:lua_repl_command
  elseif executable('luap')
    let lua_repl = 'luap'
  elseif !empty(luaexe)
    let lua_repl = luaexe + ['-i']
  else
    let lua_repl = ['lua', '-i']
  endif
  call spacevim#plugins#repl#reg('lua', lua_repl)
  call spacevim#layers#edit#add_ft_head_tamplate('lua', s:lua_file_head)
  " Format on save
  if s:format_on_save
    call spacevim#layers#format#add_filetype({
          \ 'filetype' : 'lua',
          \ 'enable' : 1,
          \ })
  endif
endfunction

function! spacevim#layers#lang#lua#set_variable(opt) abort
  let s:lua_repl_command = get(a:opt, 'repl_command', '') 
  let s:lua_foldmethod = get(a:opt, 'foldmethod', 'manual')
  let s:format_on_save = get(a:opt, 'format_on_save', s:format_on_save)
endfunction

" Add language specific mappings
function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','b'], 'LuaCompile', 'lua compile', 1)
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("lua")',
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
  if spacevim#layers#lsp#check_filetype('lua')
        \ || spacevim#layers#lsp#check_server('lua_ls')
        \ || spacevim#layers#lsp#check_server('sumneko_lua')
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
endfunction

function! spacevim#layers#lang#lua#health() abort
  call spacevim#layers#lang#lua#plugins()
  call spacevim#layers#lang#lua#config()
  return 1
endfunction

function! spacevim#layers#lang#lua#loadable() abort

  return 1

endfunction
