"=============================================================================
" projectmanager.vim --- project manager for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================

function! spacevim#plugins#projectmanager#complete_project(ArgLead, CmdLine, CursorPos) abort
  return luaeval('require("spacevim.plugin.projectmanager").complete_project('
        \ .'require("spacevim.api.vim.compatible").eval("a:ArgLead"),'
        \ .'require("spacevim.api.vim.compatible").eval("a:CmdLine"),'
        \ .'require("spacevim.api.vim.compatible").eval("a:CursorPos"))')
endfunction

function! spacevim#plugins#projectmanager#OpenProject(p) abort
  lua require("spacevim.plugin.projectmanager").OpenProject(
        \ require("spacevim.api.vim.compatible").eval("a:p")
        \ )
endfunction

function! spacevim#plugins#projectmanager#list() abort
  lua require("spacevim.plugin.projectmanager").list()
endfunction

function! spacevim#plugins#projectmanager#open(project) abort
  lua require("spacevim.plugin.projectmanager").open(
        \ require("spacevim.api.vim.compatible").eval("a:project")
        \ )
endfunction

function! spacevim#plugins#projectmanager#current_name() abort
  return luaeval('require("spacevim.plugin.projectmanager").current_name()')
endfunction

function! spacevim#plugins#projectmanager#RootchandgeCallback() abort
  lua require("spacevim.plugin.projectmanager").RootchandgeCallback()
endfunction

function! spacevim#plugins#projectmanager#reg_callback(func, ...) abort
  if a:0 == 0
    lua require("spacevim.plugin.projectmanager").reg_callback(
          \ require("spacevim.api.vim.compatible").eval("string(a:func)")
          \ )
  else
    lua require("spacevim.plugin.projectmanager").reg_callback(
          \ require("spacevim.api.vim.compatible").eval("string(a:func)"),
          \ require("spacevim.api.vim.compatible").eval("a:1")
          \ )
  endif
endfunction

function! spacevim#plugins#projectmanager#current_root() abort
  return luaeval('require("spacevim.plugin.projectmanager").current_root()')
endfunction

function! spacevim#plugins#projectmanager#kill_project() abort
  lua require("spacevim.plugin.projectmanager").kill_project()
endfunction

" vim:set et nowrap sw=2 cc=80:
