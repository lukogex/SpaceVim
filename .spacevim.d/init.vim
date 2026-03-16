"=============================================================================
" init.vim --- local config for spacevim development
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let g:spacevim_force_global_config = 1
call spacevim#custom#SPC('nnoremap', ['a', 'r'], 'call spacevim#dev#releases#open()', 'Release spacevim', 1)
call spacevim#custom#SPC('nnoremap', ['a', 'w'], 'call spacevim#dev#website#open()', 'Open spacevim local website', 1)
call spacevim#custom#SPC('nnoremap', ['a', 't'], 'call spacevim#dev#website#terminal()', 'Close spacevim local website', 1)

" after run make test, the vader will be downloaded to ./build/vader/

let &runtimepath .= ',' . fnamemodify(g:_spacevim_root_dir, ':p:h') . '/build/vader'

augroup vader_filetype
  autocmd!
  autocmd FileType vader-result setlocal nobuflisted
augroup END

" vader language specific key bindings

function! s:language_specified_mappings() abort
  call spacevim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'Vader',
        \ 'execute current file', 1)
endfunction
call spacevim#plugins#a#set_config_name(getcwd(), '.spacevim.d/projections.toml')
call spacevim#mapping#space#regesit_lang_mappings('vader', function('s:language_specified_mappings'))
command! -nargs=1 IssueEdit call spacevim#dev#issuemanager#edit(<f-args>)
command! -nargs=1 PullCreate call spacevim#dev#pull#create(<f-args>)
command! -nargs=1 PullMerge call spacevim#dev#pull#merge(<f-args>)
command! Releasespacevim call spacevim#dev#releases#open()
command! -nargs=* -complete=file Profile call spacevim#dev#profile#run(<f-args>)
