"=============================================================================
" factor.vim --- factor language support
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! spacevim#layers#lang#factor#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-factor', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#factor#config() abort
  " call spacevim#plugins#repl#reg('prolog', 'swipl -q')
  call spacevim#plugins#runner#reg_runner('factor', 'factor.exe %s')
  call spacevim#mapping#space#regesit_lang_mappings('factor', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  " let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  " call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        " \ 'call spacevim#plugins#repl#start("factor")',
        " \ 'start REPL process', 1)
  " call spacevim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        " \ 'call spacevim#plugins#repl#send("line")',
        " \ 'send line and keep code buffer focused', 1)
  " call spacevim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        " \ 'call spacevim#plugins#repl#send("buffer")',
        " \ 'send buffer and keep code buffer focused', 1)
  " call spacevim#mapping#space#langSPC('nmap', ['l','s', 's'],
        " \ 'call spacevim#plugins#repl#send("selection")',
        " \ 'send selection and keep code buffer focused', 1)
endfunction

" ref:
" - https://www.howtoforge.com/linux-factor-command/
" - https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46


function! spacevim#layers#lang#factor#health() abort
  call spacevim#layers#lang#factor#plugins()
  call spacevim#layers#lang#factor#config()
  return 1
endfunction
