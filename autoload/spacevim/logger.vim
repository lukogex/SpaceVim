"=============================================================================
" logger.vim --- spacevim logger
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================

""
" @section Runtime Log, runtime-log
" @parentsection dev
" The runtime log of spacevim can be obtained via the key binding `SPC h L`.
" To get the debug information about the current spacevim environment,
" Use the command `:SPDebugInfo!`. This command will open a new buffer where default information will be shown.
" You can also use `SPC h I` to open a buffer with spacevim's issue template.

""
" write message to spacevim runtime log with `info` level.
function! spacevim#logger#info(msg) abort
  lua require("spacevim.logger").info(
        \ require("spacevim.api.vim.compatible").eval("a:msg")
        \ )
endfunction

""
" write warning {msg} to spacevim runtime log.
" The `msg` must be string. the second argument is optional, It can a
" boolean or `0/1`. By default, the warning message will not be printed,
" if the second argument is given, and is `0` or false, the warning msg
" will be printed to screen.
function! spacevim#logger#warn(msg, ...) abort
  let issilent = get(a:000, 0, 1)
  lua require("spacevim.logger").warn(
        \ require("spacevim.api.vim.compatible").eval("a:msg"),
        \ require("spacevim.api.vim.compatible").eval("issilent")
        \ )
endfunction

""
" write error message to spacevim runtime log.
function! spacevim#logger#error(msg) abort
  lua require("spacevim.logger").error(
        \ require("spacevim.api.vim.compatible").eval("a:msg")
        \ )
endfunction

""
" write debug message to spacevim runtime log.
function! spacevim#logger#debug(msg) abort
  lua require("spacevim.logger").debug(
        \ require("spacevim.api.vim.compatible").eval("a:msg")
        \ )
endfunction

""
" This a a function to view the spacevim runtime log. same as
" |:SPRuntimeLog| and `SPC h L`
"
" To clear runtime log, just run:
" >
"   :SPRuntimeLog --clear
" <
function! spacevim#logger#viewRuntimeLog(...) abort
  if get(a:000, 0, '') ==# '--clear'
    lua require("spacevim.logger").clearRuntimeLog()
    return
  endif
  lua require("spacevim.logger").viewRuntimeLog()
endfunction

""
" Print the debug information of spacevim, same as |:SPDebugInfo|
function! spacevim#logger#viewLog(...) abort
  if a:0 >= 1
    let bang = get(a:000, 0, 0)
    return luaeval('require("spacevim.logger").viewLog(require("spacevim.api.vim.compatible").eval("bang"))')
  else
    return luaeval('require("spacevim.logger").viewLog()')
  endif
endfunction

""
" @public
" Set debug level of spacevim. Default is 1.
"
"     1 : log all messages
"
"     2 : log warning and error messages
"
"     3 : log error messages only
function! spacevim#logger#setLevel(level) abort
  lua require("spacevim.logger").setLevel(require("spacevim.api.vim.compatible").eval("a:level"))
endfunction

""
" change the output file of spacevim runtime logger. default is empty
" string.
function! spacevim#logger#setOutput(file) abort
  lua require("spacevim.logger").setOutput(require("spacevim.api.vim.compatible").eval("a:file"))
endfunction

""
" Derive a new logger based on spacevim's runtime logger. The new logger
" provides following functions:
" 1. info(msg): like |spacevim#logger#info|, but include the derive name.
" 2. warn(msg): like |spacevim#logger#warn|
" 3. error(msg): like |spacevim#logger#error|
" 4. debug(msg): write debug message run spacevim runtime log
" 5. start_debug(): enable debug mode of derived logger.
" 6. stop_debug(): stop debug mode of derived logger.
" 7. debug_enabled(): return true or false.
"
" This function can be used in vim script and lua.
"
" Vim script Example: >
"   let s:LOGGER = spacevim#logger#derive('myplug')
"
"   call s:LOGGER.info('hello world')
" <
"
" Lua Example: >
"   local log = require('spacevim.logger').derive('myplug')
"
"   log.info('hello world')
" <
"
" The this info message will be write to spacevim's runtime log:
" >
"   [  myplug ] [00:02:54:051] [ Info  ] hello world
" <
function! spacevim#logger#derive(name) abort
  return luaeval('require("spacevim.logger").derive(require("spacevim.api.vim.compatible").eval("a:name"))')
endfunction
