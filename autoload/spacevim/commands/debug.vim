"=============================================================================
" debug.vim --- debug tool for spacevim command
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:debug_message = []
function! spacevim#commands#debug#completion_debug(ArgLead, CmdLine, CursorPos) abort
    call add(s:debug_message, 'arglead:['.a:ArgLead .'] cmdline:[' .a:CmdLine .'] cursorpos:[' .a:CursorPos .']')
endfunction

function! spacevim#commands#debug#get_message() abort
    return join(s:debug_message, "\n")
endfunction

function! spacevim#commands#debug#clean_message() abort
   let s:debug_message = []
   return s:debug_message
endfunction
