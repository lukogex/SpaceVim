""
" @section codingagent, layers-codingagent
" @parentsection layers
" This layer provides agentic coding capabilities using opencode.nvim.
" It allows you to interact with an AI coding agent directly within Neovim.
"
" @subsection Key Bindings
" >
"   Key Bindings    | Descriptions
"   --------------- | ----------------------------------------
"   SPC a c t       | Toggle OpenCode panel
"   SPC a c o       | Open OpenCode input
"   SPC a c c       | Quick chat with buffer/selection
"   SPC a c f       | Add current file to context
"   SPC a c s       | Stop Agent generation
"   SPC a c q       | Close OpenCode
" <

function! spacevim#layers#codingagent#plugins() abort
  let plugins = []
  " Check if dependencies are already in bundle, otherwise use repo URLs
  if isdirectory(expand(g:_spacevim_root_dir . 'bundle/plenary.nvim'))
    call add(plugins, [g:_spacevim_root_dir . 'bundle/plenary.nvim', {'merged' : 0}])
  else
    call add(plugins, ['nvim-lua/plenary.nvim', {'merged' : 0}])
  endif

  if isdirectory(expand(g:_spacevim_root_dir . 'bundle/nui.nvim'))
    call add(plugins, [g:_spacevim_root_dir . 'bundle/nui.nvim', {'merged' : 0}])
  else
    call add(plugins, ['MunifTanjim/nui.nvim', {'merged' : 0}])
  endif

  " opencode.nvim
  call add(plugins, ['sudo-tee/opencode.nvim', {
        \ 'merged' : 0,
        \ 'loadconf' : 1,
        \ }])
  
  return plugins
endfunction

let s:api_key = ''
let s:model = 'gpt-4o'
let s:auto_context = 1

function! spacevim#layers#codingagent#set_variable(var) abort
  let s:api_key = get(a:var, 'api_key', s:api_key)
  let s:model = get(a:var, 'model', s:model)
  let s:auto_context = get(a:var, 'auto_context', s:auto_context)
endfunction

function! spacevim#layers#codingagent#config() abort
  " Ensure the 'a' submenu (Applications) and 'c' submenu (Agent Coding) exist
  let g:_spacevim_mappings_space.a = get(g:_spacevim_mappings_space, 'a', {'name' : '+Applications'})
  let g:_spacevim_mappings_space.a.c = get(g:_spacevim_mappings_space.a, 'c', {'name' : '+Agent Coding'})

  call spacevim#mapping#space#def('nnoremap', ['a', 'c', 't'], 'Opencode toggle', 'toggle-opencode-chat', 1)
  call spacevim#mapping#space#def('nnoremap', ['a', 'c', 'o'], 'Opencode open', 'open-opencode-input', 1)
  call spacevim#mapping#space#def('nnoremap', ['a', 'c', 'c'], 'Opencode quick_chat', 'quick-chat-with-buffer', 1)
  call spacevim#mapping#space#def('vnoremap', ['a', 'c', 'c'], 'Opencode quick_chat', 'quick-chat-with-selection', 1)
  call spacevim#mapping#space#def('nnoremap', ['a', 'c', 'f'], 'lua require("opencode.context").add_file(expand("%:p"))', 'add-current-file-to-context', 1)
  call spacevim#mapping#space#def('nnoremap', ['a', 'c', 's'], 'Opencode cancel', 'stop-agent-generation', 1)
  call spacevim#mapping#space#def('nnoremap', ['a', 'c', 'q'], 'Opencode close', 'close-opencode', 1)

  let g:opencode_api_key = s:api_key
  let g:opencode_model = s:model
  let g:opencode_auto_context = s:auto_context

  lua << EOF
  require('opencode').setup({
    default_global_keymaps = false,
    keymap_prefix = '',
  })
  EOF
endfunction

function! spacevim#layers#codingagent#get_options() abort
  return ['api_key', 'model', 'auto_context']
endfunction

function! spacevim#layers#codingagent#health() abort
  call spacevim#layers#codingagent#plugins()
  call spacevim#layers#codingagent#config()
  return 1
endfunction

function! spacevim#layers#codingagent#loadable() abort
  return has('nvim-0.9.0')
endfunction
