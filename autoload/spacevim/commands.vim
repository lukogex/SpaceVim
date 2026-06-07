"=============================================================================
" commands.vim --- commands in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================

function! spacevim#commands#load() abort
  ""
  " Load exist layer, {layers} can be a string of a layer name, or a list
  " of layer names.
  command! -nargs=+ SPLayer call spacevim#layers#load(<f-args>)
  ""
  " Print the version of spacevim.  The following lines contain information
  " about which features were enabled.  When there is a preceding '+', the
  " feature is included, when there is a '-' it is excluded.
  command! -nargs=0 SPVersion call spacevim#commands#version()
  ""
  " Set or check spacevim option. {opt} should be the option name of
  " spacevim, This command will use [value] as the value of option name.
  command! -nargs=+ -complete=custom,spacevim#commands#complete_options
        \ SPSet call spacevim#options#set(<f-args>)
  ""
  " print the debug information of spacevim, [!] forces the output into a
  " new buffer.
  command! -nargs=0 -bang SPDebugInfo call spacevim#logger#viewLog('<bang>' == '!')
  ""
  " view runtime log
  command! -nargs=* SPRuntimeLog call spacevim#logger#viewRuntimeLog(<f-args>)
  ""
  " edit custom config file of spacevim, by default this command will open
  " global custom configuration file, '-l' option will load local custom
  " configuration file.
  " >
  "   :SPConfig -g
  " <
  command! -nargs=*
        \ -complete=customlist,spacevim#commands#complete_SPConfig
        \ SPConfig call spacevim#commands#config(<f-args>)
  ""
  " Command for update plugin, support completion of plugin name. If run
  " without argv, All the plugin will be updated.
  " >
  "     :SPUpdate vim-airline
  " <
  command! -nargs=*
        \ -complete=custom,spacevim#commands#complete_plugin
        \ SPUpdate call spacevim#commands#update_plugin(<f-args>)

  ""
  " Command for reinstall plugin, support completion of plugin name. 
  command! -nargs=+
        \ -complete=custom,spacevim#commands#complete_plugin
        \ SPReinstall call spacevim#commands#reinstall_plugin(<f-args>)

  ""
  " Command for install plugins.
  command! -nargs=* SPInstall call spacevim#commands#install_plugin(<f-args>)
  command! -nargs=* SPClean call spacevim#commands#clean_plugin()
  command! -nargs=0 Report call spacevim#issue#new()
  " Convenient command to see the difference between the current buffer and the
  " file it was loaded from, thus the changes you made.  Only define it when not
  " defined already.
  command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
  ""
  " Open specific project in @section(options-src_root)
  command! -nargs=+ -complete=custom,spacevim#plugins#projectmanager#complete_project OpenProject :call spacevim#plugins#projectmanager#OpenProject(<f-args>)

  command! -nargs=* -complete=custom,spacevim#plugins#pmd#complete PMD :call spacevim#plugins#pmd#run(<f-args>)


  ""
  " Switch to alternate file based on {type}. for more info about alternate
  " file configuration, checkout @section(plugins-alternate)
  command! -nargs=? -complete=custom,spacevim#plugins#a#complete -bang A :call spacevim#plugins#a#alt(<bang>0,<f-args>)
endfunction

" @vimlint(EVL103, 1, a:ArgLead)
" @vimlint(EVL103, 1, a:CmdLine)
" @vimlint(EVL103, 1, a:CursorPos)
function! spacevim#commands#complete_plugin(ArgLead, CmdLine, CursorPos) abort
  return join(keys(dein#get()) + ['spacevim'], "\n")
endfunction
" @vimlint(EVL103, 0, a:ArgLead)
" @vimlint(EVL103, 0, a:CmdLine)
" @vimlint(EVL103, 0, a:CursorPos)

" @vimlint(EVL103, 1, a:ArgLead)
" @vimlint(EVL103, 1, a:CmdLine)
" @vimlint(EVL103, 1, a:CursorPos)
function! spacevim#commands#complete_SPConfig(ArgLead, CmdLine, CursorPos) abort
  return ['-g', '-l']
endfunction
" @vimlint(EVL103, 0, a:ArgLead)
" @vimlint(EVL103, 0, a:CmdLine)
" @vimlint(EVL103, 0, a:CursorPos)

function! spacevim#commands#config(...) abort
  if a:0 > 0
    if a:1 ==# '-g'
      exe 'tabnew' g:_spacevim_global_config_path
    elseif  a:1 ==# '-l'
      exe 'tabnew' g:_spacevim_config_path
    endif
  else
    if g:spacevim_force_global_config ||
          \ get(g:, '_spacevim_config_path', '0') ==# '0'
      exe 'tabnew' g:_spacevim_global_config_path
    else
      exe 'tabnew' g:_spacevim_config_path
    endif
  endif
  setlocal omnifunc=spacevim#custom#complete
endfunction

function! spacevim#commands#update_plugin(...) abort
  if a:0 == 0
    call spacevim#plugins#manager#update()
  else
    call spacevim#plugins#manager#update(a:000)
  endif
endfunction

function! spacevim#commands#reinstall_plugin(...) abort
  call spacevim#plugins#manager#reinstall(a:000)
endfunction

function! spacevim#commands#clean_plugin() abort
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endfunction

function! spacevim#commands#install_plugin(...) abort
  if a:0 == 0
    call spacevim#plugins#manager#install()
  else
    call spacevim#plugins#manager#install(a:000)
  endif
endfunction

function! spacevim#commands#version() abort
  echo 'spacevim ' . g:spacevim_version  . s:SHA() . "\n" .
        \ "\n" .
        \ 'Optional features included (+) or not (-):' . "\n" .
        \ s:check_features([
        \ 'tui',
        \ 'jemalloc',
        \ 'acl',
        \ 'arabic',
        \ 'autocmd',
        \ 'browse',
        \ 'byte_offset',
        \ 'cindent',
        \ 'clientserver',
        \ 'clipboard',
        \ 'cmdline_compl',
        \ 'cmdline_hist',
        \ 'cmdline_info',
        \ 'comments',
        \ 'conceal',
        \ 'cscope',
        \ 'cursorbind',
        \ 'cursorshape',
        \ 'debug',
        \ 'dialog_gui',
        \ 'dialog_con',
        \ 'dialog_con_gui',
        \ 'digraphs',
        \ 'eval',
        \ 'ex_extra',
        \ 'extra_search',
        \ 'farsi',
        \ 'file_in_path',
        \ 'find_in_path',
        \ 'folding',
        \ 'gettext',
        \ 'iconv',
        \ 'iconv/dyn',
        \ 'insert_expand',
        \ 'jumplist',
        \ 'keymap',
        \ 'langmap',
        \ 'libcall',
        \ 'linebreak',
        \ 'lispindent',
        \ 'listcmds',
        \ 'localmap',
        \ 'menu',
        \ 'mksession',
        \ 'modify_fname',
        \ 'mouse',
        \ 'mouseshape',
        \ 'multi_byte',
        \ 'multi_byte_ime',
        \ 'multi_lang',
        \ 'path_extra',
        \ 'persistent_undo',
        \ 'postscript',
        \ 'printer',
        \ 'profile',
        \ 'python',
        \ 'python3',
        \ 'quickfix',
        \ 'reltime',
        \ 'rightleft',
        \ 'scrollbind',
        \ 'shada',
        \ 'signs',
        \ 'smartindent',
        \ 'startuptime',
        \ 'statusline',
        \ 'syntax',
        \ 'tablineat',
        \ 'tag_binary',
        \ 'tag_old_static',
        \ 'tag_any_white',
        \ 'termguicolors',
        \ 'terminfo',
        \ 'termresponse',
        \ 'textobjects',
        \ 'tgetent',
        \ 'timers',
        \ 'title',
        \ 'toolbar',
        \ 'user_commands',
        \ 'vertsplit',
        \ 'virtualedit',
        \ 'visual',
        \ 'visualextra',
        \ 'vreplace',
        \ 'wildignore',
        \ 'wildmenu',
        \ 'windows',
        \ 'writebackup',
        \ 'xim',
        \ 'xfontset',
        \ 'xpm',
        \ 'xpm_w32',
        \ ])
endfunction

function! s:check_features(features) abort
  let flist = map(a:features, "(has(v:val) ? '+' : '-') . v:val")
  let rst = ''
  let id = 1
  for f in flist
    let rst .= '    '
    let rst .= f . repeat(' ', 20 - len(f))
    if id == 3
      let rst .= "\n"
      let id = 1
    else
      let id += 1
    endif
  endfor
  return substitute(rst, '\n*\s*$', '', 'g')
endfunction

function! s:SHA() abort
  let sha = system('git --no-pager -C ~/.spacevim  log -n 1 --oneline')[:7]
  if v:shell_error
    return ''
  endif
  return '-' . sha
endfunction

function! spacevim#commands#complete_options(...)
  return join(map(getcompletion('g:spacevim_','var'), 'v:val[11:]'), "\n")
endfunction

" vim:set et sw=2 cc=80:
