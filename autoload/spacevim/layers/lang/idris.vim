"=============================================================================
" idris.vim --- idris language support
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#idris, layers-lang-idris
" @parentsection layers
" This layer is for idris development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#idris'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for idris, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"


function! spacevim#layers#lang#idris#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-idris', { 'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#idris#config() abort
  call spacevim#plugins#repl#reg('idris', 'idris --nobanner')
  call spacevim#plugins#runner#reg_runner('idris', ['idris %s -o #TEMP#', '#TEMP#'])
  call spacevim#mapping#space#regesit_lang_mappings('idris', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("idris")',
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
  call spacevim#mapping#space#langSPC('nnoremap', ['l','w'], 'call idris#makeWith()', 'add-with-clause', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','t'], 'call idris#showType()', 'show-type', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','p'], 'call idris#proofSearch(1)', 'proof-search', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','o'], 'call idris#proofSearch(1)', 'obvious-proof-search', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','a'], 'call idris#reload(0)', 'reload-file', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','c'], 'call idris#caseSplit()', 'case-split', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','f'], 'call idris#refine()', 'refine-item', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','l'], 'call idris#makeLemma()', 'make lemma', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','h'], 'call idris#showDoc()', 'show doc', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','m'], 'call idris#addMissing()', 'add missing', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','e'], 'call idris#eval()', 'idris eval', 1)
  call spacevim#mapping#space#langSPC('nnoremap', ['l','i'], 'call idris#responseWin()', 'open-response-win', 1)
  let g:_spacevim_mappings_space.l.d = {'name' : '+Add clause'}
  call spacevim#mapping#space#langSPC('nnoremap', ['l','d', 'f'], '0:call search(":")<ENTER>b:call idris#addClause(0)<ENTER>w', 'add-clause-for-type-declaration', 1, 0)

  " nnoremap <buffer> <silent> <LocalLeader>b 0:call IdrisAddClause(0)<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>md 0:call search(":")<ENTER>b:call IdrisAddClause(1)<ENTER>w
  " nnoremap <buffer> <silent> <LocalLeader>mc :call IdrisMakeCase()<ENTER>
endfunction

function! spacevim#layers#lang#idris#health() abort
  call spacevim#layers#lang#idris#plugins()
  call spacevim#layers#lang#idris#config()
  return 1
endfunction
