"=============================================================================
" init.vim --- Entry file for neovim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================

" set default encoding to utf-8
" Let Vim use utf-8 internally, because many scripts require this
set encoding=utf-8
scriptencoding utf-8

" Enable nocompatible
if &compatible
  set nocompatible
endif

let g:_spacevim_root_dir = escape(fnamemodify(resolve(fnamemodify(expand('<sfile>'), ':p:h:gs?\\?')), ':p:gs?[\\/]?/?'), ' ')
lockvar g:_spacevim_root_dir

if has('nvim')
  " Even when not supported explicitely lets keep this to not break when a user adds it to the runtimepath.
  " The nvim-qt check is used to ensure that any runtime paths related to the Neovim-Qt GUI are moved to the front of the runtimepath.
  " nvim-qt often provides its own set of scripts (like those for handling GUI-specific features, fonts, or windowing).
  " If these paths are buried deep in the runtimepath, they might be overridden by other plugins or SpaceVim's own defaults, leading to broken GUI functionality.
  let rtps = []
  for rtp in split(&rtp, ',')
    if rtp =~# 'nvim-qt'
      call insert(rtps, 0, rtp)
    else
      call add(rtps, rtp)
    endif
  endfor
  let &rtp = join(rtps, ',')
else
  call spacevim#logger#warning('Spacevim from version 3 onwards only supports Neovim.')
endif

call spacevim#logger#info('Loading spacevim from: ' . g:_spacevim_root_dir)
call spacevim#logger#info('default rtp is:')
call map(split(&rtp, ','), 'spacevim#logger#info("  > " . v:val)')

if has('vim_starting')
  " python host
  " @bug python2 error on neovim 0.6.1
  " let g:loaded_python_provider = 0
  if !empty($PYTHON_HOST_PROG)
    let g:python_host_prog  = $PYTHON_HOST_PROG
    call spacevim#logger#info('$PYTHON_HOST_PROG is not empty, setting g:python_host_prog:' . g:python_host_prog)
  endif
  if !empty($PYTHON3_HOST_PROG)
    let g:python3_host_prog = $PYTHON3_HOST_PROG
    call spacevim#logger#info('$PYTHON3_HOST_PROG is not empty, setting g:python3_host_prog:' . g:python3_host_prog)
  endif
endif

call spacevim#begin()

call spacevim#custom#load()

if has('timers')
  call timer_start(g:spacevim_lazy_conf_timeout, 'spacevim#default#keyBindings') 
else
  call spacevim#default#keyBindings()
endif


call spacevim#end()

call spacevim#logger#info('finished loading spacevim!')
" vim:set et sw=2 cc=80:
