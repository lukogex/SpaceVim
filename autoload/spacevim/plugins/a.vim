"=============================================================================
" a.vim --- plugin for manager alternate file
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

""
" @section alternate, plugins-alternate
" @parentsection plugins
" To manage the alternate file of the project, you need to create a `.project_alt.json` file
" in the root of your project. Then you can use the command `:A` to jump to the alternate file of
" current file. You can also specific the type of alternate file, for example `:A doc`.
" With a bang `:A!`, spacevim will parse the configuration file additionally. If no type is specified,
" the default type `alternate` will be used.
" 
" here is an example of `.project_alt.json`:
" 
" >
"   {
"     "autoload/spacevim/layers/lang/*.vim": {
"       "doc": "docs/layers/lang/{}.md",
"       "test": "test/layer/lang/{}.vader"
"     }
"   }
" <
" 
" instead of using `.project_alt.json`, `b:alternate_file_config`
" can be used in bootstrap function, for example:
" 
" >
"   augroup myspacevim
"       autocmd!
"       autocmd BufNewFile,BufEnter *.c let b:alternate_file_config = {
"             \ "src/*.c" : {
"                 \ "doc" : "docs/{}.md",
"                 \ "alternate" : "include/{}.h",
"                 \ }
"             \ }
"       autocmd BufNewFile,BufEnter *.h let b:alternate_file_config = {
"             \ "include/*.h" : {
"                 \ "alternate" : "scr/{}.c",
"                 \ }
"             \ }
"   augroup END
" <

function! spacevim#plugins#a#alt(request_parse, ...) abort
  lua require("spacevim.plugin.a").alt(
        \ require("spacevim.api.vim.compatible").eval("a:request_parse"),
        \ require("spacevim.api.vim.compatible").eval("a:000")
        \ )
endfunction

function! spacevim#plugins#a#set_config_name(path, name) abort
  lua require("spacevim.plugin.a").set_config_name(
        \ require("spacevim.api.vim.compatible").eval("a:path"),
        \ require("spacevim.api.vim.compatible").eval("a:name")
        \ )
endfunction

function! spacevim#plugins#a#getConfigPath() abort
  return luaeval('require("spacevim.plugin.a").getConfigPath()')
endfunction

function! spacevim#plugins#a#complete(ArgLead, CmdLine, CursorPos) abort
  return luaeval('require("spacevim.plugin.a").complete('
        \ .'require("spacevim.api.vim.compatible").eval("a:ArgLead"),'
        \ .'require("spacevim.api.vim.compatible").eval("a:CmdLine"),'
        \ .'require("spacevim.api.vim.compatible").eval("a:CursorPos"))')
endfunction

function! spacevim#plugins#a#get_alt(file, conf_path, request_parse,...) abort
  let type = get(a:000, 0, 'alternate')
  return luaeval('require("spacevim.plugin.a").get_alt('
        \ . 'require("spacevim.api.vim.compatible").eval("a:file"),'
        \ . 'require("spacevim.api.vim.compatible").eval("a:conf_path"),'
        \ . 'require("spacevim.api.vim.compatible").eval("a:request_parse"),'
        \ . 'require("spacevim.api.vim.compatible").eval("type"))')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et sw=2 cc=80:
