"=============================================================================
" logger.vim --- spacevim logger
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section Runtime Log, runtime-log
" @parentsection dev
" The runtime log of spacevim can be obtained via the key binding `SPC h L`.
" To get the debug information about the current spacevim environment,
" Use the command `:SPDebugInfo!`. This command will open a new buffer where default information will be shown.
" You can also use `SPC h I` to open a buffer with spacevim's issue template.


if has('nvim-0.5.0')
  ""
  " write message to spacevim runtime log with `info` level.
  function! spacevim#logger#info(msg) abort
    lua require("spacevim.logger").info(
          \ require("spacevim").eval("a:msg")
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
          \ require("spacevim").eval("a:msg"),
          \ require("spacevim").eval("issilent")
          \ )
  endfunction

  ""
  " write error message to spacevim runtime log.
  function! spacevim#logger#error(msg) abort
    lua require("spacevim.logger").error(
          \ require("spacevim").eval("a:msg")
          \ )
  endfunction

  ""
  " write debug message to spacevim runtime log.
  function! spacevim#logger#debug(msg) abort
    lua require("spacevim.logger").debug(
          \ require("spacevim").eval("a:msg")
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
      return luaeval('require("spacevim.logger").viewLog(require("spacevim").eval("bang"))')
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
    lua require("spacevim.logger").setLevel(require("spacevim").eval("a:level"))
  endfunction
  ""
  " change the output file of spacevim runtime logger. default is empty
  " string.
  function! spacevim#logger#setOutput(file) abort
    lua require("spacevim.logger").setOutput(require("spacevim").eval("a:file"))
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
    return luaeval('require("spacevim.logger").derive(require("spacevim").eval("a:name"))')
  endfunction
else
  let s:LOGGER = spacevim#api#import('logger')

  call s:LOGGER.set_name('spacevim')
  call s:LOGGER.set_level(get(g:, 'spacevim_debug_level', 1))
  call s:LOGGER.set_silent(1)
  call s:LOGGER.set_verbose(1)

  function! spacevim#logger#info(msg) abort

    call s:LOGGER.info(a:msg)

  endfunction

  function! spacevim#logger#warn(msg, ...) abort
    let issilent = get(a:000, 0, 1)
    call s:LOGGER.warn(a:msg, issilent)
  endfunction


  function! spacevim#logger#error(msg) abort

    call s:LOGGER.error(a:msg)

  endfunction

  function! spacevim#logger#debug(msg) abort

    call s:LOGGER.debug(a:msg)

  endfunction

  function! spacevim#logger#viewRuntimeLog(...) abort
    if get(a:000, 0, '') ==# '--clear'
      call s:LOGGER.clear()
      return
    endif
    let info = "### spacevim runtime log :\n\n"
    let info .= s:LOGGER.view(s:LOGGER.level)
    tabnew +setl\ nobuflisted
    nnoremap <buffer><silent> q :tabclose!<CR>
    call setline(1, split(info, "\n"))
    normal! G
    setl nomodifiable
    setl buftype=nofile
    setl filetype=spacevimLog
  endfunction


  function! spacevim#logger#viewLog(...) abort
    let info = "<details><summary> spacevim debug information </summary>\n\n"
    let info .= "### spacevim options :\n\n"
    let info .= "```toml\n"
    let info .= join(spacevim#options#list(), "\n")
    let info .= "\n```\n"
    let info .= "\n\n"

    let info .= "### spacevim layers :\n\n"
    let info .= spacevim#layers#report()
    let info .= "\n\n"

    let info .= "### spacevim Health checking :\n\n"
    let info .= spacevim#health#report()
    let info .= "\n\n"

    let info .= "### spacevim runtime log :\n\n"
    let info .= "```log\n"

    let info .= s:LOGGER.view(s:LOGGER.level)

    let info .= "\n```\n</details>\n\n"
    if a:0 > 0
      if a:1 == 1
        tabnew +setl\ nobuflisted
        nnoremap <buffer><silent> q :bd!<CR>
        for msg in split(info, "\n")
          call append(line('$'), msg)
        endfor
        normal! "_dd
        setl nomodifiable
        setl buftype=nofile
        setl filetype=markdown
      else
        echo info
      endif
    else
      return info
    endif
  endfunction

  function! s:syntax_extra() abort
    call matchadd('ErrorMsg','.*[\sError\s\].*')
    call matchadd('WarningMsg','.*[\sWarn\s\].*')
  endfunction

  function! spacevim#logger#setLevel(level) abort
    call s:LOGGER.set_level(a:level)
  endfunction

  function! spacevim#logger#setOutput(file) abort
    call s:LOGGER.set_file(a:file)
  endfunction


  " derive a logger for built-in plugins
  " [ name ] [11:31:26] [ Info ] log message here

  let s:derive = {}
  let s:derive.origin_name = s:LOGGER.get_name()
  let s:derive._debug_mode = 1

  function! s:derive.info(msg) abort
    call s:LOGGER.set_name(self.derive_name)
    call s:LOGGER.info(a:msg)
    call s:LOGGER.set_name(self.origin_name)
  endfunction

  function! s:derive.warn(msg) abort
    call s:LOGGER.set_name(self.derive_name)
    call s:LOGGER.warn(a:msg)
    call s:LOGGER.set_name(self.origin_name)
  endfunction

  function! s:derive.error(msg) abort
    call s:LOGGER.set_name(self.derive_name)
    call s:LOGGER.error(a:msg)
    call s:LOGGER.set_name(self.origin_name)
  endfunction

  function! s:derive.debug(msg) abort
    if self._debug_mode
      call s:LOGGER.set_name(self.derive_name)
      call s:LOGGER.debug(a:msg)
      call s:LOGGER.set_name(self.origin_name)
    endif
  endfunction

  function! s:derive.start_debug() abort
    let self._debug_mode = 1
  endfunction

  function! s:derive.stop_debug() abort
    let self._debug_mode = 0
  endfunction

  function! s:derive.debug_enabled() abort
    return self._debug_mode
  endfunction

  function! spacevim#logger#derive(name) abort
    let s:derive.derive_name = printf('%' . strdisplaywidth(s:LOGGER.get_name()) . 'S', a:name)
    return deepcopy(s:derive)
  endfunction
endif
