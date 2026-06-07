"=============================================================================
" lsp.vim --- language server protocol wallpaper
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Seong Yong-ju < @sei40kr >
" License: GPLv3
"=============================================================================

scriptencoding utf-8

if exists('s:NVIM_VERSION')
  finish
endif

let s:NVIM_VERSION = spacevim#api#import('neovim#version')
let s:box = spacevim#api#import('unicode#box')
let s:NOTI = spacevim#api#import('notify')

" use neovim built-in lsp
call spacevim#logger#info('lsp client: nvim built-in lsp')

function! spacevim#lsp#reg_server(ft, cmds) abort
  lua require("spacevim.lsp").register(
        \ require("spacevim.api.vim.compatible").eval("a:ft"),
        \ require("spacevim.api.vim.compatible").eval("a:cmds")
        \ )
endfunction

function! spacevim#lsp#show_doc() abort
  lua vim.lsp.buf.hover()
endfunction

function! spacevim#lsp#go_to_def() abort
  lua vim.lsp.buf.definition()
endfunction

function! spacevim#lsp#go_to_declaration() abort
  lua vim.lsp.buf.declaration()
endfunction

function! spacevim#lsp#rename() abort
  " @todo add float prompt api
  " lua vim.lsp.buf.rename(require('spacevim.api.input').float_prompt())
  lua vim.lsp.buf.rename()
endfunction

function! spacevim#lsp#references() abort
  lua vim.lsp.buf.references()
endfunction

function! spacevim#lsp#go_to_typedef() abort
endfunction

function! spacevim#lsp#refactor() abort
endfunction

function! spacevim#lsp#go_to_impl() abort
  lua vim.lsp.buf.implementation()
endfunction

function! spacevim#lsp#show_line_diagnostics() abort
  lua require('spacevim.diagnostic').open_float()
endfunction

function! spacevim#lsp#list_workspace_folder() abort
  let workspace = luaeval('vim.lsp.buf.list_workspace_folders()')
  let bw = max(map(deepcopy(workspace), 'strwidth(v:val)')) + 5
  let box = s:box.drawing_box(workspace, 1, 1, bw, {'align' : 'left'})
  call s:NOTI.notify(join(box, "\n"))
endfunction

function! spacevim#lsp#add_workspace_folder() abort
  lua vim.lsp.buf.add_workspace_folder()
endfunction

function! spacevim#lsp#remove_workspace_folder() abort
  lua vim.lsp.buf.remove_workspace_folder()
endfunction

function! spacevim#lsp#buf_server_ready() abort
  return luaeval('require("spacevim.lsp").server_ready()')
endfunction

function! spacevim#lsp#diagnostic_set_loclist() abort
  lua require('spacevim.diagnostic').set_loclist()
endfunction

function! spacevim#lsp#diagnostic_goto_next() abort
  lua require("spacevim.diagnostic").goto_next()
endfunction

function! spacevim#lsp#diagnostic_goto_prev() abort
  lua require("spacevim.diagnostic").goto_prev()
endfunction

function! spacevim#lsp#diagnostic_clear() abort
  lua require("spacevim.diagnostic").hide()
endfunction
