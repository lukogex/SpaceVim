"=============================================================================
" pascal.vim --- pascal language support in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#pascal, layers-lang-pascal
" @parentsection layers
" This layer is for pascal development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#pascal'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <

let s:SYS = spacevim#api#import('system')

function! spacevim#layers#lang#pascal#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-pascal', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#pascal#config() abort
  call spacevim#mapping#space#regesit_lang_mappings('pascal', function('s:language_specified_mappings'))
  if s:SYS.isWindows
    let runner = ['fpc %s -FE#TEMP#.exe', '#TEMP#.exe']
  else
    let runner = ['fpc %s -o#TEMP#', '#TEMP#']
  endif
  call spacevim#plugins#runner#reg_runner('pascal', runner)
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call spacevim#plugins#runner#open()',
        \ 'compile and run current file', 1)
endfunction

function! spacevim#layers#lang#pascal#health() abort
  call spacevim#layers#lang#pascal#plugins()
  call spacevim#layers#lang#pascal#config()
  return 1
endfunction
