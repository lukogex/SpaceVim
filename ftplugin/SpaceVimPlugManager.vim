"=============================================================================
" spacevimPlugManager.vim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('g:_spacevimPlugManager_ftplugin')
  finish
else
  let g:_spacevimPlugManager_ftplugin = 1
endif
function! spacevimPlugManager#statusline(...)
    if &ft ==# 'spacevimPlugManager'
        call airline#extensions#apply_left_override('spacevimPlugins', '')
        " Alternatively, set the various w:airline_section variables
        "let w:airline_section_a = 'spacevimPluginManager'
        "let w:airline_section_b = ''
        "let w:airline_section_c = ''
        "let w:airline_render_left = 1
        "let w:airline_render_right = 0
    endif
endfunction
try
    call airline#add_statusline_func('spacevimPlugManager#statusline')
catch
endtry
