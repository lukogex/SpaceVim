local M = {}

-- TODO: The layer functions should return a list of all plugins, or at least it should be possible.
function M.plugins()
  return {
    "sudo-tee/opencode.nvim",
    opts = M.config(),
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { 'markdown', 'opencode_output' },
        },
        ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
      },
      -- Optional, for file mentions and commands completion, pick only one
      -- 'saghen/blink.cmp',
      -- TODO: Use nvim-cmp by now due to a missing dependency blink.lib, but we might look back to it as it promisses to be faster.
      'hrsh7th/nvim-cmp',

      -- Optional, for file mentions picker, pick only one
      -- 'folke/snacks.nvim',
      'nvim-telescope/telescope.nvim',
      -- 'ibhagwan/fzf-lua',
      -- 'nvim_mini/mini.nvim',
    }
  }
end

function M.config()
  -- Ensure the 'a' submenu (Applications) and 'c' submenu (Agent Coding) exist
  vim.cmd "let g:_spacevim_mappings_space.a = get(g:_spacevim_mappings_space, 'a', {'name' : '+Applications'})"
  vim.cmd "let g:_spacevim_mappings_space.a.c = get(g:_spacevim_mappings_space.a, 'c', {'name' : '+Agent Coding'})"

  vim.cmd "call spacevim#mapping#space#def('nnoremap', ['a', 'c', 't'], 'Opencode toggle', 'toggle-opencode-chat', 1)"
  vim.cmd "call spacevim#mapping#space#def('nnoremap', ['a', 'c', 'o'], 'Opencode open', 'open-opencode-input', 1)"
  vim.cmd "call spacevim#mapping#space#def('nnoremap', ['a', 'c', 'c'], 'Opencode quick_chat', 'quick-chat-with-buffer', 1)"
  vim.cmd "call spacevim#mapping#space#def('vnoremap', ['a', 'c', 'c'], 'Opencode quick_chat', 'quick-chat-with-selection', 1)"
  -- vim.cmd "call spacevim#mapping#space#def('nnoremap', ['a', 'c', 'f'], 'lua require("opencode.context").add_file(expand("%:p"))', 'add-current-file-to-context', 1)"
  vim.cmd "call spacevim#mapping#space#def('nnoremap', ['a', 'c', 's'], 'Opencode cancel', 'stop-agent-generation', 1)"
  vim.cmd "call spacevim#mapping#space#def('nnoremap', ['a', 'c', 'q'], 'Opencode close', 'close-opencode', 1)"

  return require("config.opencode")
end

function M.set_variable(var)
end

function M.get_variable()
end

return M
