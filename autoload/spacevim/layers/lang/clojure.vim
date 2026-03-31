"=============================================================================
" clojure.vim --- spacevim lang#clojure layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#clojure, layers-lang-clojure
" @parentsection layers
" This layer provides clojure language support in spacevim. Including syntax
" highlighting, code indent, code runner and REPL. This layer is not enabled
" by default, To enable this layer:
" >
"   [[layers]]
"     name = "lang#clojure"
" <
"
" @subsection layer options
"
" 1. `clojure_interpreter`: Set the clojure interpreter, by default, it is
" `clojure`
" >
"   [[layers]]
"     name = 'lang#clojure'
"     clojure_interpreter = 'path/to/clojure'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for clojure, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"
" If the lsp layer is enabled for clojure, the following key bindings can
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
" @subsection Tasks
" spacevim will detect lein project tasks automatically. If there is
" `project.clj` file in the root directory of your project. Following tasks
" will be detected:
"
" 1. `lein:test`
" 2. `lein:run`

if exists('s:clojure_interpreter')
  finish
endif

let s:clojure_interpreter = 'clojure'

function! spacevim#layers#lang#clojure#plugins() abort
  let plugins = []
  if !spacevim#layers#lsp#check_filetype('clojure')
        \ && !spacevim#layers#lsp#check_server('clojure_lsp')
    " if has('nvim')
    " call add(plugins, ['clojure-vim/acid.nvim', {'merged' : 0}])
    " call add(plugins, ['clojure-vim/async-clj-highlight', {'merged' : 0}])
    call add(plugins, ['clojure-vim/async-clj-omni', {'merged' : 0}])
    " else
    " for vim, use guns's clojure plugin guide
    call add(plugins, ['guns/vim-clojure-static', {'merged' : 0}])
    call add(plugins, ['guns/vim-clojure-highlight', {'merged' : 0}])
  endif
  " endif
  if g:spacevim_lint_engine ==# 'syntastic'
    call add(plugins, ['venantius/vim-eastwood', {'merged' : 0}])
  endif
  call add(plugins, ['tpope/vim-fireplace', {'merged' : 0}])
  call add(plugins, ['venantius/vim-cljfmt', {'merged' : 0}])
  return plugins
endfunction


function! spacevim#layers#lang#clojure#config() abort
  call spacevim#mapping#space#regesit_lang_mappings('clojure', function('s:language_specified_mappings'))
  " in Window, if install clojure via scoop install clojure, the command is
  " cmd-clj
  " let clojure = get(filter(['cmd-clj'], 'executable(v:val)'), 0, 'clojure')
  call spacevim#plugins#runner#reg_runner('clojure', s:clojure_interpreter . ' -M %s')
  call spacevim#plugins#repl#reg('clojure', s:clojure_interpreter)
  call spacevim#plugins#tasks#reg_provider(function('s:lein_tasks'))
  call add(g:spacevim_project_rooter_patterns, 'project.clj')
endfunction

" Add language specific mappings
function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("clojure")',
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
  if spacevim#layers#lsp#check_filetype('clojure')
        \ || spacevim#layers#lsp#check_server('clojure_lsp')
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

function! s:lein_tasks() abort
  let detect_task = {}
  if filereadable('project.clj')
    for task_name in ['run', 'test']
      call extend(detect_task, {
            \ task_name : {'command' : 'lein', 'args' : [task_name], 'isDetected' : 1, 'detectedName' : 'lein:'}
            \ })
    endfor
  endif
  return detect_task
endfunction

function! spacevim#layers#lang#clojure#set_variable(var) abort
  let s:clojure_interpreter = get(a:var, 'clojure_interpreter', s:clojure_interpreter)
endfunction

function! spacevim#layers#lang#clojure#health() abort
  call spacevim#layers#lang#clojure#plugins()
  call spacevim#layers#lang#clojure#config()
  return 1
endfunction

function! spacevim#layers#lang#clojure#loadable() abort

  return 1

endfunction
