"=============================================================================
" guide.vim --- key binding guide for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================

scriptencoding utf-8
if exists('s:save_cpo')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

""
" @section Mapping Guide, plugins-mapping-guide
" @parentsection plugins
" The mapping guide windows will be opened each time the prefix key is pressed
" in normal/visual mode. It will list all available key bindings and the short
" descriptions. The prefix can be `[SPC]`, `[WIN]` or `<Leader>`.
"
" The prefixes are mapped to the following key bindings by default:
" >
"   Prefix    | Custom options and default values | Descriptions
"   ---------------------------------------------------------------------
"   [SPC]`    | NONE / `<Space>`                  | default mapping prefix
"   [WIN]`    | `windows_leader` / `s`            | window mapping prefix
"   <Leader>` | default vim leader                | default leader prefix
" <
"
" The default value of `<Leader>` is `\`, if you want to change this key,
" you need to use the bootstrap function. For example, to use `,`
" as the `<Leader>` key:
" >
"   function! myspacevim#before() abort
"     let g:mapleader = ','
"   endfunction
" <
"
" NOTE: When modifying the variable `g:mapleader` in a function.
" you can not omit the variable's scope. Because the default scope
" of a variable in function is `l:`. It is different from what you
" see in vim help |mapleader|.
"
" By default the guide buffer will be displayed 1000ms after the keys being pressed.
" You can change the delay by adding vim option `'timeoutlen'` to your bootstrap function.
"
" For example, after pressing `<Space>` in normal mode, you will see all the
" key bindings start with `SPC` in mapping guide windows.
" you can type `b` for all the buffer mappings, `p` for project mappings, etc.
"
" After pressing `Ctrl-h` in guide buffer, you will get paging and help info in the statusline.
" >
"   | Keys | Descriptions                  |
"   | ---- | ----------------------------- |
"   | `u`  | undo pressing                 |
"   | `n`  | next page of guide buffer     |
"   | `p`  | previous page of guide buffer |
" <
" Use `spacevim#custom#SPC()` to define custom SPC mappings. For example:
" >
"   call spacevim#custom#SPC('nnoremap',
"     \ ['f', 't'],
"     \ 'echom "hello world"', 'test custom SPC', 1)
" <
"
" The first parameter sets the type of shortcut key,
" which can be `nnoremap` or `nmap`, the second parameter is a list of keys,
" and the third parameter is an ex command or key binding,
" depending on whether the last parameter is true.
" The fourth parameter is a short description of this custom key binding.
"
" @subsection Fuzzy find key bindings
"
" It is possible to search for specific key bindings by pressing `?`
" in the root of the guide buffer.
"
" To narrow the list down, just insert the mapping keys or descriptions of
" what mappings you want, the fuzzy finder will get the mappings.
"
" Then use `<Tab>` or `<Up>` and `<Down>` to select the mapping,
" press `<Enter>` to execute that command.
"
" @subsection Mapping guide theme
"
" The default mapping guide theme is `leaderguide`,
" which is same as vim-leaderguide(https://github.com/hecal3/vim-leader-guide),
" there is another available theme called `whichkey`.
" To set the mapping guide theme, use following snippet:
" >
"   [options]
"     # the value can be `leaderguide` or `whichkey`
"     leader_guide_theme = 'whichkey'
" <

function! spacevim#mapping#guide#parse_mappings() abort " {{{
  lua require("spacevim.plugin.guide").parse_mappings()
endfunction "}}}

function! spacevim#mapping#guide#start(vis, dict) abort " {{{
  lua require("spacevim.plugin.guide").start(
        \ require("spacevim.api.vim.compatible").eval("a:vis"),
        \ require("spacevim.api.vim.compatible").eval("a:dict")
        \ )
endfunction "}}}

function! spacevim#mapping#guide#has_configuration() abort "{{{
  return luaeval('require("spacevim.plugin.guide").has_configuration()')
endfunction "}}}

function! spacevim#mapping#guide#start_by_prefix(vis, key) abort " {{{
  lua require("spacevim.plugin.guide").start_by_prefix(
        \ require("spacevim.api.vim.compatible").eval("a:vis"),
        \ require("spacevim.api.vim.compatible").eval("a:key")
        \ )
endfunction "}}}

function! spacevim#mapping#guide#register_displayname(lhs, name) abort
  lua require("spacevim.plugin.guide").register_displayname(
        \ require("spacevim.api.vim.compatible").eval("a:lhs"),
        \ require("spacevim.api.vim.compatible").eval("a:name")
        \ )
endfunction "}}}

function! spacevim#mapping#guide#populate_dictionary(key, dictname) abort " {{{
  lua require("spacevim.plugin.guide").populate_dictionary(
        \ require("spacevim.api.vim.compatible").eval("a:key"),
        \ require("spacevim.api.vim.compatible").eval("a:dictname")
        \ )
endfunction "}}}

function! spacevim#mapping#guide#register_prefix_descriptions(key, dictname) abort " {{{
  lua require("spacevim.plugin.guide").register_prefix_descriptions(
        \ require("spacevim.api.vim.compatible").eval("a:key"),
        \ require("spacevim.api.vim.compatible").eval("a:dictname")
        \ )
endfunction "}}}

function! spacevim#mapping#guide#displayfunc() abort
  lua require("spacevim.plugin.guide").displayfunc()
endfunction

if !exists('g:leaderGuide_displayfunc')
  let g:leaderGuide_displayfunc = [function('spacevim#mapping#guide#displayfunc')]
endif

if get(g:, 'mapleader', '\') ==# ' '
  call spacevim#mapping#guide#register_prefix_descriptions(' ',
        \ 'g:_spacevim_mappings')
else
  call spacevim#mapping#guide#register_prefix_descriptions(get(g:, 'mapleader', '\'),
        \ 'g:_spacevim_mappings')
  call spacevim#plugins#help#regist_root({'<Leader>' : g:_spacevim_mappings})
  call spacevim#mapping#guide#register_prefix_descriptions(' ',
        \ 'g:_spacevim_mappings_space')
  call spacevim#plugins#help#regist_root({'SPC' : g:_spacevim_mappings_space})
endif
if !g:spacevim_vimcompatible && !empty(g:spacevim_windows_leader)
  call spacevim#mapping#guide#register_prefix_descriptions(
        \ g:spacevim_windows_leader,
        \ 'g:_spacevim_mappings_windows')
  call spacevim#plugins#help#regist_root({'[WIN]' : g:_spacevim_mappings_windows})
endif
call spacevim#mapping#guide#register_prefix_descriptions(
      \ '[KEYs]',
      \ 'g:_spacevim_mappings_prefixs')
call spacevim#mapping#guide#register_prefix_descriptions(
      \ 'g',
      \ 'g:_spacevim_mappings_g')
call spacevim#plugins#help#regist_root({'[g]' : g:_spacevim_mappings_g})
call spacevim#mapping#guide#register_prefix_descriptions(
      \ 'z',
      \ 'g:_spacevim_mappings_z')
call spacevim#plugins#help#regist_root({'[z]' : g:_spacevim_mappings_z})
let [s:lsep, s:rsep] = spacevim#layers#core#statusline#rsep()
let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et sw=2 cc=80:
