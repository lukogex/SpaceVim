"=============================================================================
" racket.vim --- racket language support in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#racket, layers-lang-racket
" @parentsection layers
" This layer is for racket development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#racket'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for racket, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! spacevim#layers#lang#racket#plugins() abort
  let plugins = []
  call add(plugins, ['wlangstroth/vim-racket', {'merged' : 0}])
  return plugins
endfunction


function! spacevim#layers#lang#racket#config() abort
  augroup spacevim_layer_lang_racket
    autocmd!
    au BufRead,BufNewFile *.rkt,*.rktl setf racket
  augroup END
  call spacevim#plugins#runner#reg_runner('racket', 
        \ {
        \ 'exe' : 'racket',
        \ 'opt' : ['-t'],
        \ 'usestdin' : 0,
        \ })
  call spacevim#mapping#gd#add('racket', function('s:go_to_def'))
  call spacevim#plugins#repl#reg('racket', ['racket', '-i'])
  call spacevim#mapping#space#regesit_lang_mappings('racket', function('s:language_specified_mappings'))
endfunction

function! s:go_to_def() abort

endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call spacevim#plugins#runner#open()',
        \ 'execute current file', 1)
  " nnoremap <silent><buffer> K :call spacevim#lsp#show_doc()<CR>
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("racket")',
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

function! spacevim#layers#lang#racket#health() abort
  call spacevim#layers#lang#racket#plugins()
  call spacevim#layers#lang#racket#config()
  return 1
endfunction
