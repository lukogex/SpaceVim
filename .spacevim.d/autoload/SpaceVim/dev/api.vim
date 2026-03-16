"=============================================================================
" api.vim --- Develop script for update api index
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:FILE = spacevim#api#import('file')
let s:SYS = spacevim#api#import('system')
let s:CMP = spacevim#api#import('vim#compatible')


let s:AUTODOC = spacevim#api#import('dev#autodoc')
let s:AUTODOC.autoformat = 1

function! spacevim#dev#api#update() abort
  let s:AUTODOC.begin = '^<!-- spacevim api list start -->$'
  let s:AUTODOC.end = '^<!-- spacevim api list end -->$'
  let s:AUTODOC.content_func = function('s:generate_content')
  call s:AUTODOC.update()
endfunction

function! spacevim#dev#api#updateCn() abort
  let s:AUTODOC.begin = '^<!-- spacevim api cn list start -->$'
  let s:AUTODOC.end = '^<!-- spacevim api cn list end -->$'
  let s:AUTODOC.content_func = function('s:generate_content_cn')
  call s:AUTODOC.update()
endfunction


function! s:generate_content_cn() abort
  let content = ['', '## 可用 APIs', '']
  let content += s:api_list_cn()
  let content += ['']
  return content
endfunction

function! s:generate_content() abort
  let content = ['', '## Available APIs', '', 'Here is the list of all available APIs, and welcome to contribute to spacevim.', '']
  let content += s:api_list()
  let content += ['']
  return content
endfunction

function! s:api_list() abort
  let layers = s:CMP.globpath('~/.spacevim/', 'docs/api/**/*.md')
  let list = [
        \ '| Name | Description |',
        \ '| ---------- | ------------ |'
        \ ]
  if s:SYS.isWindows
    let pattern = join(['', 'docs', 'api', ''], s:FILE.separator . s:FILE.separator)
  else
    let pattern = join(['', 'docs', 'api', ''], s:FILE.separator)
  endif
  for layer in layers
    let name = split(layer, pattern)[1][:-4] . s:FILE.separator
    let url = join(split(name, s:FILE.separator), '/') . '/'
    let content = readfile(layer)
    if len(content) > 3
      let line = '| [' . join(split(name, s:FILE.separator), '#') . '](' . url . ')    |   ' . content[2][14:-2] . ' | '
    else
      let line = '| [' . join(split(name, s:FILE.separator), '#') . '](' . url . ')    |   can not find Description |'
    endif
    call add(list, line)
  endfor
  return list
endfunction

function! s:api_list_cn() abort
  let layers = s:CMP.globpath('~/.spacevim/', 'docs/cn/api/**/*.md')
  let list = [
        \ '| 名称 | 描述 |',
        \ '| ---------- | ------------ |'
        \ ]
  if s:SYS.isWindows
    let pattern = join(['', 'docs', 'cn', 'api', ''], s:FILE.separator . s:FILE.separator)
  else
    let pattern = join(['', 'docs', 'cn', 'api', ''], s:FILE.separator)
  endif
  for layer in layers
    let name = split(layer, pattern)[1][:-4] . s:FILE.separator
    let url = join(split(name, s:FILE.separator), '/') . '/'
    let content = readfile(layer)
    if len(content) > 3
      let line = '| [' . join(split(name, s:FILE.separator), '#') . '](' . url . ')    |   ' . content[2][14:-2] . ' | '
    else
      let line = '| [' . join(split(name, s:FILE.separator), '#') . '](' . url . ')    |   can not find Description |'
    endif
    call add(list, line)
  endfor
  return list
endfunction
