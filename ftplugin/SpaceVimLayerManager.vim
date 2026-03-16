"=============================================================================
" spacevimLayerManager.vim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('g:_spacevimLayerManager_ftplugin')
  finish
else
  let g:_spacevimLayerManager_ftplugin = 1
endif
function! spacevimLayerManager#statusline(...)
    if &ft ==# 'spacevimLayerManager'
        call airline#extensions#apply_left_override('spacevimLayers', '')
        " Alternatively, set the various w:airline_section variables
        "let w:airline_section_a = 'spacevimPluginManager'
        "let w:airline_section_b = ''
        "let w:airline_section_c = ''
        "let w:airline_render_left = 1
        "let w:airline_render_right = 0
    endif
endfunction
try
    call airline#add_statusline_func('spacevimLayerManager#statusline')
catch
endtry
