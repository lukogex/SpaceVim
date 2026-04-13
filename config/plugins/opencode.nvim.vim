if !has('nvim')
  finish
endif

lua << EOF
require('opencode').setup({
  api_key = vim.g.opencode_api_key or "",
  model = vim.g.opencode_model or "gpt-4o",
  auto_context = vim.g.opencode_auto_context == 1,
  -- SpaceVim style UI integration
  ui = {
    icons = {
      agent = "󱚧 ",
      user = " ",
    },
  },
})
EOF

" Define commands if the plugin doesn't define them globally
command! OpenCodeToggle lua require('opencode').toggle()
command! OpenCodeChat lua require('opencode').chat()
command! OpenCodeAddFile lua require('opencode').add_file()
command! OpenCodeReset lua require('opencode').reset()
command! OpenCodeStop lua require('opencode').stop()
