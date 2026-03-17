"=============================================================================
" health.vim --- spacevim health checker
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================

let s:CMP = spacevim#api#import('vim#compatible')


function! spacevim#health#report() abort
  let items = map(s:CMP.globpath(&rtp,'autoload/spacevim/health/*'), "fnamemodify(v:val,':t:r')")
  let report = []
  for item in items
    try
      let result = spacevim#health#{item}#check()
      call extend(report,result)
    catch /^Vim\%((\a\+)\)\=:E117/
      call extend(report,[
            \ '',
            \ 'spacevim Health Error:',
            \ '    There is no function: spacevim#health#' . item . '#check()',
            \ '',
            \ ])
    endtry
  endfor
  return join(report + s:check_layers(), "\n")
endfunction


function! s:check_layers() abort
  let report = ['Checking spacevim layer health:']
  for layer in spacevim#layers#get()
    try
      let result = spacevim#layers#{layer}#health() ? 'ok' : 'failed'
      call extend(report, ['  - `'   . layer . '`:' . result])
    catch /^Vim\%((\a\+)\)\=:E117/
      call extend(report, ['  - `'   . layer . '`: can not find function: spacevim#layers#' . layer . '#health()'])
    endtry
  endfor
  return report
endfunction

" vim:set et sw=2:
