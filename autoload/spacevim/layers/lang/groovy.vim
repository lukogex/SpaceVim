"=============================================================================
" groovy.vim --- groovy support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#groovy, layers-lang-groovy
" @parentsection layers
" This layer is for groovy development, disabled by default, to enable this
" layer, add following snippet to your spacevim configuration file.
" >
"   [[layers]]
"     name = 'lang#groovy'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for groovy, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"


function! spacevim#layers#lang#groovy#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/groovy.vim', {'merged' : 0}])
  return plugins
endfunction

function! spacevim#layers#lang#groovy#config() abort
  call spacevim#plugins#repl#reg('groovy', 'groovysh')
  call spacevim#plugins#runner#reg_runner('groovy', 'groovy %s')
  call spacevim#mapping#space#regesit_lang_mappings('groovy', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'], 'call spacevim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call spacevim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call spacevim#plugins#repl#start("groovy")',
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


" C:\Users\Administrator\.spacevim>groovy -v
" WARNING: An illegal reflective access operation has occurred
" WARNING: Illegal reflective access by org.codehaus.groovy.vmplugin.v7.Java7$1 (file:/D:/scoop/apps/groovy/current/lib/groovy-2.5.7.jar) to constr
" uctor java.lang.invoke.MethodHandles$Lookup(java.lang.Class,int)
" WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.vmplugin.v7.Java7$1
" WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
" WARNING: All illegal access operations will be denied in a future release
" Groovy Version: 2.5.7 JVM: 9.0.4 Vendor: Oracle Corporation OS: Windows 7
" in windows, use scoop to instal jdk 1.8
" scoop install ojdkbuild8


function! spacevim#layers#lang#groovy#health() abort
  call spacevim#layers#lang#groovy#plugins()
  call spacevim#layers#lang#groovy#config()
  return 1
endfunction
