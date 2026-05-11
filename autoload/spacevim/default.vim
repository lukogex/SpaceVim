"=============================================================================
" default.vim --- default options in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:SYSTEM = spacevim#api#import('system')
let s:TAB = spacevim#api#import('vim#tab')

function! spacevim#default#keyBindings(...) abort
  call spacevim#logger#info('init default key bindings.')
  xnoremap <silent> <Leader>y :<C-u>call clipboard#yank()<cr>
  nnoremap <expr> <Leader>p clipboard#paste('p')
  nnoremap <expr> <Leader>P clipboard#paste('P')
  xnoremap <expr> <Leader>p clipboard#paste('p')
  xnoremap <expr> <Leader>P clipboard#paste('P')
  let g:_spacevim_mappings.p = ['normal! "+p', 'paste after here']
  let g:_spacevim_mappings.P = ['normal! "+P', 'paste before here']

  xnoremap <silent><Leader>Y :<C-u>call spacevim#plugins#pastebin#paste()<CR>
  " call spacevim#mapping#guide#register_displayname(':call spacevim#plugins#pastebin#paste()<CR>', 'copy to pastebin')

  " quickfix list movement
  let g:_spacevim_mappings.q = {'name' : '+Quickfix movement'}
  call spacevim#mapping#def('nnoremap', '<Leader>qn', ':cnext<CR>',
        \ 'Jump to next quickfix list position',
        \ 'cnext',
        \ 'Next quickfix list')
  call spacevim#mapping#def('nnoremap', '<Leader>qp', ':cprev<CR>',
        \ 'Jump to previous quickfix list position',
        \ 'cprev',
        \ 'Previous quickfix list')
  call spacevim#mapping#def('nnoremap', '<Leader>ql', ':copen<CR>',
        \ 'Open quickfix list window',
        \ 'copen',
        \ 'Open quickfix list window')
  call spacevim#mapping#def('nnoremap <silent>', '<Leader>qr', 'q',
        \ 'Toggle recording',
        \ '',
        \ 'Toggle recording mode')
  call spacevim#mapping#def('nnoremap <silent>', '<Leader>qc', ':call setqflist([])<CR>',
        \ 'Clear quickfix list',
        \ '',
        \ 'Clear quickfix')

  " Use Ctrl+* to jump between windows
  nnoremap <silent><C-Right> :<C-u>wincmd l<CR>
  nnoremap <silent><C-Left>  :<C-u>wincmd h<CR>
  nnoremap <silent><C-Up>    :<C-u>wincmd k<CR>
  nnoremap <silent><C-Down>  :<C-u>wincmd j<CR>


  "]<End> or ]<Home> move current line to the end or the begin of current buffer
  nnoremap <silent>]<End> ddGp``
  nnoremap <silent>]<Home> ddggP``
  vnoremap <silent>]<End> dGp``
  vnoremap <silent>]<Home> dggP``


  "Ctrl+Shift+Up/Down to move up and down
  nnoremap <silent><C-S-Down> :m .+1<CR>==
  nnoremap <silent><C-S-Up> :m .-2<CR>==
  inoremap <silent><C-S-Down> <Esc>:m .+1<CR>==gi
  inoremap <silent><C-S-Up> <Esc>:m .-2<CR>==gi
  vnoremap <silent><C-S-Down> :m '>+1<CR>gv=gv
  vnoremap <silent><C-S-Up> :m '<-2<CR>gv=gv

  " Start new line
  inoremap <S-Return> <C-o>o

  if maparg('<c-g>', 'n') == ''
    nnoremap <silent> <c-g> :<c-u>call spacevim#plugins#ctrlg#display()<cr>
  endif

  nnoremap <silent> <C-`> :<c-u>call spacevim#plugins#runner#close()<Cr>


  " Improve scroll, credits: https://github.com/Shougo
  nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
        \ 'zt' : (winline() == &scrolloff + 1) ? 'zb' : 'zz'

  " Select blocks after indenting
  xnoremap < <gv
  xnoremap > >gv|

  " Use tab for indenting in visual mode
  xnoremap <Tab> >gv|
  xnoremap <S-Tab> <gv
  nnoremap > >>_
  nnoremap < <<_

  " smart up and down
  nnoremap <silent><Down> gj
  nnoremap <silent><Up> gk

  " Fast saving
  nnoremap <C-s> :<C-u>w<CR>
  vnoremap <C-s> :<C-u>w<CR>
  cnoremap <C-s> <C-u>w<CR>

  nnoremap <silent> gr :<C-u>call <SID>switch_tabs()<CR>

  " Remove spaces at the end of lines
  nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

  " C-r: Easier search and replace
  xnoremap <C-r> :<C-u>call <SID>VSetSearch()<CR>:,$s/<C-R>=@/<CR>//gc<left><left><left>
  function! s:VSetSearch() abort
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  "irssi like hot key
  nnoremap <silent><M-1> :<C-u>call <SID>tobur(1)<CR>
  nnoremap <silent><M-2> :<C-u>call <SID>tobur(2)<CR>
  nnoremap <silent><M-3> :<C-u>call <SID>tobur(3)<CR>
  nnoremap <silent><M-4> :<C-u>call <SID>tobur(4)<CR>
  nnoremap <silent><M-5> :<C-u>call <SID>tobur(5)<CR>
  nnoremap <silent><M-Right> :<C-U>call <SID>tobur("next")<CR>
  nnoremap <silent><M-Left> :<C-U>call <SID>tobur("prev")<CR>
  call spacevim#logger#info('default key binding init done')
endfunction

fu! s:tobur(num) abort
  if has('nvim-0.9.5')
    lua require('spacevim.plugin.tabline').jump(vim.api.nvim_eval('a:num'))
    return
  endif
  if index(get(g:,'_spacevim_altmoveignoreft',[]), &filetype) == -1
    if a:num ==# 'next'
      if tabpagenr('$') > 1
        tabnext
      else
        bnext
      endif

    elseif a:num ==# 'prev'
      if tabpagenr('$') > 1
        tabprevious
      else
        bprev
      endif
    else
      let ls = split(execute(':ls'), "\n")
      let buffers = []
      for b in ls
        let nr = matchstr(b, '\d\+')
        call add(buffers, nr)
      endfor
      if len(buffers) >= a:num
        exec 'buffer ' . buffers[a:num - 1]
      endif
    endif
  endif
endfunction

function! spacevim#default#UseSimpleMode() abort

endfunction

function! spacevim#default#Customfoldtext() abort
  "get first non-blank line
  let fs = v:foldstart
  while getline(fs) =~# '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile
  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let foldsymbol='+'
  let repeatsymbol='-'
  let prefix = foldsymbol . ' '

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = ' ' . foldSize . ' lines '
  let foldLevelStr = repeat('+--', v:foldlevel)
  let lineCount = line('$')
  let foldPercentage = printf('[%.1f', (foldSize*1.0)/lineCount*100) . '%] '
  let expansionString = repeat(repeatsymbol, w - strwidth(prefix.foldSizeStr.line.foldLevelStr.foldPercentage))
  return prefix . line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction

function! s:switch_tabs() abort
  let previous_tab = s:TAB.previous_tabpagenr()
  if previous_tab > 0
    exe 'tabnext ' . previous_tab
  endif
endfunction

" vim:set et sw=2:
