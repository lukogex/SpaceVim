"=============================================================================
" vbnet.vim --- Visual Basic .NET support
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#vbnet, layers-lang-vbnet
" @parentsection layers
" This layer is for vbnet development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#vbnet'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"

function! spacevim#layers#lang#vbnet#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-vbnet', { 'merged' : 0}])
  return plugins
endfunction


function! spacevim#layers#lang#vbnet#config() abort
  call spacevim#plugins#runner#reg_runner('vbnet', ['vbc /utf8output /nologo /out:#TEMP# %s', '#TEMP#'])
  call spacevim#mapping#space#regesit_lang_mappings('vbnet', function('s:language_specified_mappings'))
  augroup spacevim_lang_vbnet
    au!
    au! BufRead,BufNewFile *.vb setfiletype vbnet
  augroup END
endfunction
function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
endf

" ref:
" Making Vim to work in Visual Basic
" http://www.vbforums.com/showthread.php?405230-Making-Vim-to-work-in-Visual-Basic
" Folding like in Visual Basic .NET
" https://vim.fandom.com/wiki/Folding_like_in_Visual_Basic_.NET
" https://github.com/vim-scripts/VB.NET-Syntax
" https://github.com/vim-scripts/vbnet.vim
" http://www.viemu.com/viemu-vi-vim-visual-studio.html


function! spacevim#layers#lang#vbnet#health() abort
  call spacevim#layers#lang#vbnet#plugins()
  call spacevim#layers#lang#vbnet#config()
  return 1
endfunction
