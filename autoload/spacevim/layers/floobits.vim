"=============================================================================
" floobits.vim --- spacevim floobits layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! spacevim#layers#floobits#plugins() abort
  let plugins = [
        \ ['floobits/floobits-neovim',      { 'on_cmd' : [
        \ 'FlooJoinWorkspace',
        \ 'FlooShareDirPublic',
        \ 'FlooShareDirPrivate'
        \ ]}],
        \ ]
  return plugins
endfunction 

function! spacevim#layers#floobits#health() abort
  call spacevim#layers#floobits#plugins()
  call spacevim#layers#floobits#config()
  return 1
endfunction

function! spacevim#layers#floobits#config() abort
  let g:_spacevim_mappings_space.m.f = {'name' : '+floobits'}
  call spacevim#mapping#space#def('nnoremap', ['m', 'f', 'j'], 'FlooJoinWorkspace',
        \ 'Join workspace', 1)
  call spacevim#mapping#space#def('nnoremap', ['m', 'f', 't'], 'FlooToggleFollowMode',
        \ 'Toggle follow mode', 1)
  call spacevim#mapping#space#def('nnoremap', ['m', 'f', 's'], 'FlooSummon',
        \ 'Summon everyone', 1)
endfunction

