"=============================================================================
" pony.vim --- spacevim lang#pony layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#pony, layers-lang-pony
" @parentsection layers
" This layer is for pony development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#pony'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <

function! spacevim#layers#lang#pony#plugins() abort
  let plugins = []
  " .pony file type
  call add(plugins, ['wsdjeg/vim-pony', { 'on_ft' : 'pony'}])
  return plugins
endfunction

function! spacevim#layers#lang#pony#config() abort
  " @todo pony neomake support
  " in github, there is a plugin https://github.com/killerswan/pony-currycomb.vim which provides syntastic suppotr
  " checker layer configuration
  if spacevim#layers#isLoaded('checkers') && g:spacevim_lint_engine ==# 'neomake'
    let g:neomake_pony_enabled_makers = ['ponyc']
    let g:neomake_pony_ponyc_maker =  {
          \ 'args': ['--pass=expr', '.'],
          \ 'errorformat': '%f:%l:%c: %m',
          \ 'cwd': '%:p:h',
          \ }
    let g:neomake_livescript_lsc_remove_invalid_entries = 1
  endif
  let runner = {
        \ 'exe' : 'ponyc',
        \ 'targetopt' : '-o',
        \ 'opt' : [],
        \ }
  call spacevim#plugins#runner#reg_runner('pony', [runner, '#TEMP#'])
  call spacevim#mapping#space#regesit_lang_mappings('pony', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort

  call spacevim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call spacevim#plugins#runner#open()',
        \ 'execute current file', 1)
endfunction

function! spacevim#layers#lang#pony#health() abort
  call spacevim#layers#lang#pony#plugins()
  call spacevim#layers#lang#pony#config()
  return 1
endfunction
