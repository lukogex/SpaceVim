"=============================================================================
" custom.vim --- custom API in spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:TOML = spacevim#api#import('data#toml')
let s:JSON = spacevim#api#import('data#json')
let s:FILE = spacevim#api#import('file')
let s:VIM = spacevim#api#import('vim')
let s:CMP = spacevim#api#import('vim#compatible')

function! spacevim#custom#profile(dict) abort
  for key in keys(a:dict)
    call s:set(key, a:dict[key])
  endfor
endfunction


function! s:set(key,val) abort
  if !exists('g:spacevim_' . a:key)
    call spacevim#logger#warn('unsupported option: ' . a:key)
  else
    exe 'let ' . 'g:spacevim_' . a:key . '=' . a:val
  endif
endfunction

" What is your preferred editing style?
" - Among the stars aboard the Evil flagship (vim)
" - On the planet Emacs in the Holy control tower (emacs)
"
" What distribution of spacemacs would you like to start with?
" The standard distribution, recommended (spacemacs)
" A minimalist distribution that you can build on (spacemacs-base)

function! spacevim#custom#autoconfig(...) abort
  let menu = spacevim#api#import('cmdlinemenu')
  let ques = [
        \ ['basic mode', function('s:basic_mode')],
        \ ['dark powered mode', function('s:awesome_mode')],
        \ ]
  call menu.menu(ques)
endfunction



function! s:awesome_mode() abort
  let sep = s:FILE.separator
  let f = g:_spacevim_root_dir . join(['', 'mode', 'dark_powered.toml'], sep)
  let config = readfile(f, '')
  call s:write_to_config(config)
endfunction

function! s:basic_mode() abort
  let sep = s:FILE.separator
  let f = g:_spacevim_root_dir . join(['', 'mode', 'basic.toml'], sep)
  let config = readfile(f, '')
  call s:write_to_config(config)
endfunction

function! s:global_dir() abort
  if empty($SPACEVIMDIR)
    " TODO: Should we place custom configuration always in `~/.config`?
    if !empty($XDG_CONFIG_HOME)
      return s:FILE.unify_path($XDG_CONFIG_HOME.'/spacevim.d/')
    else
      return s:FILE.unify_path($HOME.'/.spacevim.d/')
    endif
  else
    return s:FILE.unify_path($SPACEVIMDIR)
  endif
endfunction

function! s:write_to_config(config) abort
  let global_dir = s:global_dir()
  let g:_spacevim_global_config_path = global_dir . 'init.toml'
  let cf = global_dir . 'init.toml'
  if filereadable(cf)
    call spacevim#logger#warn('The file already exists:' . cf)
    return
  endif
  let dir = expand(fnamemodify(cf, ':p:h'))
  if !isdirectory(dir)
    call mkdir(dir, 'p')
    let success = mkdir(dir, 'p', 0700)
    if !success
      call spacevim#logger#info('failed to create dir:' . dir)
      return
    endif
  endif
  let result = writefile(a:config, cf, '')
  if result == -1
    " failed to writefile
    call spacevim#logger#info('failed to write config to file:' . cf)
  endif
endfunction


""
" The first parameter sets the type of shortcut key,
" which can be `nnoremap` or `nmap`, the second parameter is a list of keys,
" and the third parameter is an ex command or key binding,
" depending on whether the last parameter is true.
" The fourth parameter is a short description of this custom key binding.
function! spacevim#custom#SPC(m, keys, cmd, desc, is_cmd) abort
  call add(g:_spacevim_mappings_space_custom,
        \ [a:m, a:keys, a:cmd, a:desc, a:is_cmd])
endfunction

""
" Set the group name of custom SPC key bindings.
function! spacevim#custom#SPCGroupName(keys, name) abort
  call add(g:_spacevim_mappings_space_custom_group_name, [a:keys, a:name])
endfunction
""
" function for adding custom leader key bindings
function! spacevim#custom#leader(type, key, value, ...) abort
  call add(g:_spacevim_mappings_leader_custom,
        \ [a:type, a:key, a:value] + a:000)
endfunction

""
" Set the group name of custom Leader key bindings.
function! spacevim#custom#LeaderGroupName(keys, name) abort
  call add(g:_spacevim_mappings_leader_custom_group_name, [a:keys, a:name])
endfunction


""
" This function offers user a way to add custom language specific key
" bindings.
function! spacevim#custom#LangSPC(ft, m, keys, cmd, desc, is_cmd) abort
  if !has_key(g:_spacevim_mappings_language_specified_space_custom, a:ft)
    let g:_spacevim_mappings_language_specified_space_custom[a:ft] = []
  endif
  call add(g:_spacevim_mappings_language_specified_space_custom[a:ft],
        \ [a:m, a:keys, a:cmd, a:desc, a:is_cmd])
endfunction
""
" Set the group name of custom language specific key bindings.
function! spacevim#custom#LangSPCGroupName(ft, keys, name) abort
  if !has_key(g:_spacevim_mappings_lang_group_name, a:ft)
    let g:_spacevim_mappings_lang_group_name[a:ft] = []
  endif
  call add(g:_spacevim_mappings_lang_group_name[a:ft], [a:keys, a:name])
endfunction

function! s:apply(config, type) abort
  " the type can be local or global
  " local config can override global config
  if type(a:config) != type({})
    call spacevim#logger#info('config type is wrong!')
  else
    call spacevim#logger#info('start to apply config [' . a:type . ']')
    let options = get(a:config, 'options', {})
    for [name, value] in items(options)
      if name ==# 'filemanager'
        if value ==# 'defx' && !has('python3')
          call spacevim#logger#warn('defx requires +python3!')
          continue
        elseif value ==# 'defx' && has('nvim') && !has('nvim-0.4.0')
          call spacevim#logger#warn('defx requires nvim 0.4.0+!')
          continue
        elseif value ==# 'neo-tree' && !has('nvim')
          call spacevim#logger#warn('neo-tree requires neovim')
          continue
        elseif value ==# 'nvim-tree' && !has('nvim')
          call spacevim#logger#warn('nvim-tree requires neovim')
          continue
        endif
        " keep backward compatibility
      elseif name ==# 'autocomplete_method'
        if value ==# 'deoplete' && !has('python3')
          if (has('python3') 
                \ && (spacevim#util#haspy3lib('neovim')
                \ || spacevim#util#haspy3lib('pynvim'))) &&
                \ (has('nvim') || (has('patch-8.0.0027')))
          else
            call spacevim#logger#warn('deoplete requires +python3!')
            continue
          endif
        elseif value ==# 'nvim-cmp' && !has('nvim-0.7.0')
          " https://github.com/hrsh7th/nvim-cmp/issues/231
          " nvim-cmp Breaking changes
          call spacevim#logger#warn('nvim-cmp will only work on nvim v0.7.x or higher')
          continue
        endif
      elseif name ==# 'statusline_right_sections'
        let name = 'statusline_right'
      elseif name ==# 'statusline_right_sections'
        let name = 'statusline_right'
      endif
      exe 'let g:spacevim_' . name . ' = value'
      if name ==# 'project_rooter_patterns'
            \ || name ==# 'project_rooter_outermost'
        " clear rooter cache
        call spacevim#plugins#projectmanager#current_root()
      endif
      unlet value
    endfor
    if g:spacevim_debug_level !=# 1
      call spacevim#logger#debug('change spacevim logger level to:' . g:spacevim_debug_level)
      call spacevim#logger#setLevel(g:spacevim_debug_level)
    endif
    let layers = get(a:config, 'layers', [])
    for layer in layers
      let enable = get(layer, 'enable', 1)
      let name = get(layer, 'name', '')
      if (type(enable) == type('') && !eval(enable))
            \ || (type(enable) != type('') && !enable)
        call spacevim#layers#disable(name)
      else
        call spacevim#layers#load(name, layer)
      endif
    endfor
    let custom_plugins = get(a:config, 'custom_plugins', [])
    for plugin in custom_plugins
      " name is an option for dein, we need to use repo instead
      " but we also need to keep backward compatible!
      " this the first argv should be get(plugin, 'repo', get(plugin, 'name',
      " ''))
      " BTW, we also need to check if the plugin has name or repo key
      if has_key(plugin, 'repo')
        call add(g:spacevim_custom_plugins, [plugin.repo, plugin])
      elseif has_key(plugin, 'name')
        call add(g:spacevim_custom_plugins, [plugin.name, plugin])
      else
        call spacevim#logger#warn('custom_plugins should contains repo key!')
        call spacevim#logger#info(string(plugin))
      endif
    endfor

    ""
    " @section bootstrap_before, options-bootstrap_before
    " @parentsection options
    " set the bootstrap_before function, this function will be called when
    " loading custom configuration file. for example:
    " >
    "   [options]
    "     bootstrap_before = 'myspacevim#before'
    " <

    let bootstrap_before = get(options, 'bootstrap_before', '')

    ""
    " @section bootstrap_after, options-bootstrap_after
    " @parentsection options
    " set the bootstrap_after function, this function will be called on
    " `VimEnter` event.
    " >
    "   [options]
    "     bootstrap_after = 'myspacevim#after'
    " <

    let g:_spacevim_bootstrap_after = get(options, 'bootstrap_after', '')

    ""
    " @section bootstrap_script, options-bootstrap_script
    " @parentsection options
    " set the bootstrap_script string, this string will be called via
    " `nvim_exec`, that means this option only can be used in neovim.
    " >
    "   [options]
    "     bootstrap_script = '''
    "   let g:foo_test = 1
    "   let g:zff_test = 1
    "   '''
    " <

    let bootstrap_script = get(options, 'bootstrap_script', '')

    if !empty(bootstrap_script) && exists('*nvim_exec')
      try
        call nvim_exec(bootstrap_script, 0)
      catch
        call spacevim#logger#error('failed to execute bootstrap_script.')
        call spacevim#logger#error('       exception: ' . v:exception)
        call spacevim#logger#error('       throwpoint: ' . v:throwpoint)
      endtry
    endif

    if !empty(bootstrap_before)
      try
        call spacevim#logger#info('run bootstrap_before function:' . bootstrap_before)
        call call(bootstrap_before, [])
        call spacevim#logger#info('bootstrap_before function was called successfully.')
        let g:_spacevim_bootstrap_before_success = 1
      catch
        call spacevim#logger#error('bootstrap_before function failed: '
              \ . bootstrap_before)
        call spacevim#logger#error('       exception: ' . v:exception)
        call spacevim#logger#error('       throwpoint: ' . v:throwpoint)
        let g:_spacevim_bootstrap_before_success = 0
      endtry
    endif
  endif
endfunction

function! spacevim#custom#write(force) abort
  if a:force
  endif
endfunction

function! s:path_to_fname(path) abort
  return expand(g:spacevim_data_dir.'spacevim/conf/')
        \ . substitute(a:path, '[\\/:;.]', '_', 'g') . '.json'
endfunction

function! spacevim#custom#load() abort
  call s:load_glob_conf()
  if getcwd() !=# expand('~')
    call s:load_local_conf()
  else
    call spacevim#logger#info('current directory is $HOME, skip local config')
  endif
  if g:spacevim_enable_ycm && g:spacevim_snippet_engine !=# 'ultisnips'
    call spacevim#logger#info(
          \ 'YCM only support ultisnips')
    let g:spacevim_snippet_engine = 'ultisnips'
  endif
endfunction


function! s:load_local_conf() abort
  call spacevim#logger#info('start loading local config >>>')
  if filereadable('.spacevim.d/init.toml')
    let local_dir = s:FILE.unify_path(
          \ s:CMP.resolve(fnamemodify('.spacevim.d/', ':p:h')))
    let g:_spacevim_config_path = local_dir . 'init.toml'
    let &rtp = local_dir . ',' . &rtp . ',' . local_dir . 'after'
    let local_conf = g:_spacevim_config_path
    call spacevim#logger#info('find local conf: ' . local_conf)
    let local_conf_cache = s:path_to_fname(local_conf)
    if getftime(local_conf) < getftime(local_conf_cache)
      call spacevim#logger#info('loading cached local conf: '
            \ . local_conf_cache)
      let conf = s:JSON.json_decode(join(readfile(local_conf_cache, ''), ''))
      call s:apply(conf, 'local')
    else
      try
        let conf = s:TOML.parse_file(local_conf)
        let dir = s:FILE.unify_path(expand(g:spacevim_data_dir
              \ . 'spacevim/conf/'))
        if !isdirectory(dir)
          call mkdir(dir, 'p')
        endif
        call spacevim#logger#info('generate local conf: ' . local_conf_cache)
        call writefile([s:JSON.json_encode(conf)], local_conf_cache)
        call s:apply(conf, 'local')
      catch
        call spacevim#logger#warn('failed to load local config:' . v:errmsg)
      endtry
    endif
  elseif filereadable('.spacevim.d/init.vim')
    let local_dir = s:FILE.unify_path(
          \ s:CMP.resolve(fnamemodify('.spacevim.d/', ':p:h')))
    let g:_spacevim_config_path = local_dir . 'init.vim'
    let &rtp = local_dir . ',' . &rtp . ',' . local_dir . 'after'
    let local_conf = g:_spacevim_config_path
    call spacevim#logger#info('find local conf: ' . local_conf)
  else
    call spacevim#logger#info('Could not find project local config')
  endif


endfunction

function! s:load_glob_conf() abort
  call spacevim#logger#info('start loading global config >>>')
  let global_dir = s:global_dir()
  call spacevim#logger#info('global_dir is: ' . global_dir)
  if filereadable(global_dir . 'init.toml')
    let g:_spacevim_global_config_path = global_dir . 'init.toml'
    let global_config = global_dir . 'init.toml'
    call spacevim#logger#info('find global config: ' . global_config)
    let global_config_cache = s:FILE.unify_path(expand(g:spacevim_data_dir
          \ . 'spacevim/conf/' . fnamemodify(resolve(global_config), ':t:r')
          \ . '.json'))
    let &rtp = global_dir . ',' . &rtp . ',' . global_dir . 'after'
    if getftime(resolve(global_config)) < getftime(resolve(global_config_cache))
      let conf = s:JSON.json_decode(join(readfile(global_config_cache, ''), ''))
      call s:apply(conf, 'glob')
    else
      let dir = s:FILE.unify_path(expand(g:spacevim_data_dir
            \ . 'spacevim/conf/'))
      if !isdirectory(dir)
        call mkdir(dir, 'p')
      endif
      try
        let conf = s:TOML.parse_file(global_config)
        call writefile([s:JSON.json_encode(conf)], global_config_cache)
        call s:apply(conf, 'glob')
      catch
        call spacevim#logger#warn('failed to load global config:' . v:errmsg)
      endtry
    endif
  elseif filereadable(global_dir . 'init.vim')
    let g:_spacevim_global_config_path = global_dir . 'init.vim'
    let custom_glob_conf = global_dir . 'init.vim'
    let &rtp = global_dir . ',' . &rtp . ',' . global_dir . 'after'
    exe 'source ' . custom_glob_conf
  elseif filereadable(global_dir . 'init.lua')
    let g:_spacevim_global_config_path = global_dir . 'init.lua'
    let custom_glob_conf = global_dir . 'init.lua'
    let &rtp = global_dir . ',' . &rtp . ',' . global_dir . 'after'
    exe 'luafile ' . custom_glob_conf
  else
    if has('timers')
      " if there is no custom config auto generate it.
      let g:spacevim_checkinstall = 0
      augroup spacevimBootstrap
        au!
        au VimEnter * call timer_start(2000,
              \ function('spacevim#custom#autoconfig'))
      augroup END
    endif
  endif

endfunction

" FIXME: the type should match the toml's type
function! s:opt_type(opt) abort
  " autoload/spacevim/custom.vim:221:31:Error: EVL103: unused argument `a:opt`
  " @bugupstream viml-parser seem do not think this is used argument
  let opt = a:opt
  let var = get(g:, 'spacevim_' . opt, '')
  if s:VIM.is_string(var)
    return '[string]'
  elseif s:VIM.is_bool(var)
    return '[boolean]'
  elseif s:VIM.is_number(var)
    return '[number]'
  elseif s:VIM.is_list(var)
    return '[list]'
  endif
endfunction

function! s:short_desc_of_opt(opt) abort
  if a:opt =~# '^enable_'
  else
  endif
  return ''
endfunction

function! spacevim#custom#complete(findstart, base) abort
  if a:findstart
    let s:complete_type = ''
    let s:complete_layer_name = ''
    " locate the start of the word
    let section_line = search('^\s*\[','bn')
    if section_line > 0
      if getline(section_line) =~# '^\s*\[options\]\s*$'
        if getline('.')[:col('.')-1] =~# '^\s*[a-zA-Z_]*$'
          let s:complete_type = 'spacevim_options'
        endif
      elseif getline(section_line) =~# '^\s*\[\[layers\]\]\s*$'
        let s:complete_type = 'layers_options'
        let layer_name_line = search('^\s*name\s*=','bn')
        if layer_name_line > section_line && layer_name_line < line('.')
          let s:complete_layer_name =
                \ eval(split(getline(layer_name_line), '=')[1])
        endif
      endif
    endif
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~# '[a-zA-Z_]'
      let start -= 1
    endwhile
    return start
  else
    call spacevim#logger#info('Complete spacevim configuration file:')
    call spacevim#logger#info('complete_type: ' . s:complete_type)
    call spacevim#logger#info('complete_layer_name: ' . s:complete_layer_name)
    let res = []
    if s:complete_type ==# 'spacevim_options'
      for m in map(getcompletion('g:spacevim_','var'), 'v:val[11:]')
        if m =~ '^' . a:base
          call add(res, {
                \ 'word' : m,
                \ 'kind' : s:opt_type(m),
                \ 'menu' : s:short_desc_of_opt(m),
                \ })
        endif
      endfor
    elseif s:complete_type ==# 'layers_options'
      let options = ['name']
      if !empty(s:complete_layer_name)
        try
          let options = spacevim#layers#{s:complete_layer_name}#get_options()
        catch
        endtry
      endif
      for m in options
        if m =~ '^' . a:base
          call add(res, m)
        endif
      endfor
    endif
    return res
  endif
endfunction

" vim:set et sw=2 cc=80:
