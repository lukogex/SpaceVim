if exists('s:CMP')
  finish
endif

let s:CMP = spacevim#api#import('vim#compatible')

function! spacevim#layers#bookmarks#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/bookmarks.vim',{'merged': 0, 'loadconf_before' : 1}])
  return plugins
endfunction

function! spacevim#layers#bookmarks#config() abort

  " bookmarks key binding
  nnoremap <silent> mm :<C-u>BookmarkToggle<Cr>
  nnoremap <silent> mc :<C-u>BookmarkClear<Cr>
  nnoremap <silent> mi :<C-u>BookmarkAnnotate<Cr>
  nnoremap <silent> ma :<C-u>BookmarkShowAll<Cr>
  nnoremap <silent> mn :<C-u>BookmarkNext<Cr>
  nnoremap <silent> mp :<C-u>BookmarkPrev<Cr>
  if maparg('<C-_>', 'v') ==# ''
    vnoremap <silent> <C-_> <Esc>:Ydv<CR>
  endif
  if maparg('<C-_>', 'n') ==# ''
    nnoremap <silent> <C-_> <Esc>:Ydc<CR>
  endif
endfunction
function! spacevim#layers#bookmarks#set_variable(var) abort
  let g:bookmarks_sign_text = get(a:var, 'bookmarks_sign_text', '=>')
  let g:bookmarks_sign_highlight = get(a:var, 'bookmarks_sign_highlight', 'Normal')
endfunction

function! spacevim#layers#bookmarks#health() abort
  call spacevim#layers#bookmarks#plugins()
  call spacevim#layers#bookmarks#config()
  return 1
endfunction

function! spacevim#layers#bookmarks#loadable() abort

  return 1

endfunction

" vim:set et sw=2 cc=80:
