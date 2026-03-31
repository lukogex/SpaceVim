"=============================================================================
" haskell.vim --- spacevim lang#haskell layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#haskell, layers-lang-haskell
" @parentsection layers
" This layer is for haskell development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#haskell'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for haskell, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! spacevim#layers#lang#haskell#plugins() abort
  let plugins = [
        \ ['neovimhaskell/haskell-vim', { 'on_ft': 'haskell' }],
        \ ['pbrisbin/vim-syntax-shakespeare', { 'on_ft': 'haskell' }],
        \ ]

  if spacevim#layers#lsp#check_filetype('haskell')
    call add(plugins, ['eagletmt/neco-ghc', { 'on_ft': 'haskell' }])
  endif

  return plugins
endfunction

function! spacevim#layers#lang#haskell#config() abort
  let g:haskellmode_completion_ghc = 0

  call spacevim#plugins#repl#reg('haskell', 'ghci')
  call spacevim#plugins#runner#reg_runner('haskell', [
        \ 'ghc -v0 --make %s -o #TEMP#',
        \ '#TEMP#'])
  call spacevim#mapping#space#regesit_lang_mappings('haskell',
        \ function('s:on_ft'))

  if spacevim#layers#lsp#check_filetype('haskell')
    call spacevim#mapping#gd#add('haskell',
          \ function('spacevim#lsp#go_to_def'))
  endif

  augroup spacevim_lang_haskell
    autocmd!

  if spacevim#layers#lsp#check_filetype('haskell')
      autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    endif
  augroup END
endfunction

function! s:on_ft() abort
  if spacevim#layers#lsp#check_filetype('haskell')
    nnoremap <silent><buffer> K :call spacevim#lsp#show_doc()<CR>

    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call spacevim#lsp#show_doc()', 'show_document', 1)
    call spacevim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call spacevim#lsp#rename()', 'rename symbol', 1)
  endif

  call spacevim#mapping#space#langSPC('nmap', ['l', 'r'],
        \ 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("haskell")',
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

function! spacevim#layers#lang#haskell#health() abort
  call spacevim#layers#lang#haskell#plugins()
  call spacevim#layers#lang#haskell#config()
  return 1
endfunction
