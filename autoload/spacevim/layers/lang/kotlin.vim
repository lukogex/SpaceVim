"=============================================================================
" kotlin.vim --- spacevim lang#kotlin layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#kotlin, layers-lang-kotlin
" @parentsection layers
" This layer is for kotlin development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#kotlin'
" <
" If you want to use lsp layer for kotlin, you need to install the
" kotlin_language_server.
"
" https://github.com/fwcd/kotlin-language-server
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for kotlin, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
" If the lsp layer is enabled for kotlin, the following key bindings can
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
"


" Load spacevim APIs:
let s:SYS = spacevim#api#import('system')

" Default Options:
if exists('s:enable_native_support')
  finish
else
  let s:enable_native_support = 0
endif


function! spacevim#layers#lang#kotlin#plugins() abort
  let plugins = []
  call add(plugins, ['udalov/kotlin-vim', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#kotlin#config() abort
  if g:spacevim_lint_engine ==# 'neomake'
    " neomake support:
    let g:neomake_kotlin_kotlinc_maker = {
          \ 'args': ['-cp', s:classpath(), '-d', s:outputdir()],
          \ 'errorformat':
          \ '%E%f:%l:%c: error: %m,' .
          \ '%W%f:%l:%c: warning: %m,' .
          \ '%Eerror: %m,' .
          \ '%Wwarning: %m,' .
          \ '%Iinfo: %m,'
          \ }
    let g:neomake_kotlin_ktlint_maker = {
          \ 'errorformat': '%E%f:%l:%c: %m',
          \ }
    let g:neomake_kotlin_enabled_makers = ['ktlint']
    let g:neomake_kotlin_kotlinc_remove_invalid_entries = 1
    let g:neomake_kotlin_ktlint_remove_invalid_entries = 1
  endif
  call spacevim#mapping#space#regesit_lang_mappings('kotlin', function('s:language_specified_mappings'))
  if s:enable_native_support
    let runner = {
          \ 'exe' : 'kotlinc-native'. (s:SYS.isWindows ? '.CMD' : ''),
          \ 'targetopt' : '-o',
          \ 'opt' : [],
          \ 'usestdin' : 0,
          \ }
    call spacevim#plugins#runner#reg_runner('kotlin', [runner, '#TEMP#'])
  else
    let runner = {
          \ 'exe' : 'kotlinc-jvm'. (s:SYS.isWindows ? '.CMD' : ''),
          \ 'opt' : ['-script'],
          \ 'usestdin' : 0,
          \ }
    call spacevim#plugins#runner#reg_runner('kotlin', runner)
  endif
  call spacevim#plugins#repl#reg('kotlin', ['kotlinc-jvm'. (s:SYS.isWindows ? '.CMD' : '')])
endfunction

function! s:language_specified_mappings() abort
  if spacevim#layers#lsp#check_filetype('kotlin')
        \ || spacevim#layers#lsp#check_server('kotlin_language_server')
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
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("kotlin")',
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
func! s:classpath() abort

endf

func! s:outputdir() abort

endf

function! spacevim#layers#lang#kotlin#set_variable(var) abort
  let s:enable_native_support = get(a:var,
        \ 'enable-native-support',
        \ 'nil')
endfunction

function! spacevim#layers#lang#kotlin#health() abort
  call spacevim#layers#lang#kotlin#plugins()
  call spacevim#layers#lang#kotlin#config()
  return 1
endfunction
