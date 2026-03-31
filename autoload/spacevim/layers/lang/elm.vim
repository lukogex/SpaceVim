"=============================================================================
" elixir.vim --- spacevim lang#elm layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#elm, layers-lang-elm
" @parentsection layers
" This layer is for elm development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#elm'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for elm, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"


function! spacevim#layers#lang#elm#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-elm', {'on_ft' : 'elm'}])
  return plugins
endfunction


function! spacevim#layers#lang#elm#config() abort
  call spacevim#plugins#repl#reg('elm', 'elm repl')
  call spacevim#plugins#runner#reg_runner('elm', 'elm %s')
  call spacevim#mapping#space#regesit_lang_mappings('elm', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("elm")',
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
  call spacevim#mapping#space#langSPC('nmap', ['l','m'],
        \ '<Plug>(elm-make)',
        \ 'Compile the current buffer', 0)
  call spacevim#mapping#space#langSPC('nmap', ['l','t'],
        \ '<Plug>(elm-test)',
        \ 'Runs the tests', 0)
  call spacevim#mapping#space#langSPC('nmap', ['l','e'],
        \ '<Plug>(elm-error-detail)',
        \ 'Show error detail', 0)
  call spacevim#mapping#space#langSPC('nmap', ['l','d'],
        \ '<Plug>(elm-show-docs)',
        \ 'Show symbol doc', 0)
  call spacevim#mapping#space#langSPC('nmap', ['l','w'],
        \ '<Plug>(elm-browse-docs)',
        \ 'Browse symbol doc', 0)
  nmap <buffer> K <Plug>(elm-show-docs)
  let g:elm_setup_keybindings = 0
endfunction

function! spacevim#layers#lang#elm#health() abort
  call spacevim#layers#lang#elm#plugins()
  call spacevim#layers#lang#elm#config()
  return 1
endfunction
