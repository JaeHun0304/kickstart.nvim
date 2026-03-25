-- ~/.config/nvim/lua/custom/plugins/goto.lua
return {
  -- NOTE: open specific line of file
  { 'wsdjeg/vim-fetch' },

  -- Peek definition in floating window
  {
    'rmagatti/goto-preview',
    event = 'LspAttach',
    config = function()
      require('goto-preview').setup({
        width = 120,
        height = 30,
        border = 'rounded',
        stack_floating_preview_windows = true,
        preview_window_title = { enable = true, position = 'left' },
      })
      vim.keymap.set('n', 'gp', require('goto-preview').goto_preview_definition, { desc = 'Peek definition' })
      vim.keymap.set('n', 'gP', require('goto-preview').goto_preview_references, { desc = 'Peek references' })
      vim.keymap.set('n', 'gQ', require('goto-preview').close_all_win, { desc = 'Close all peek windows' })
    end,
  },
}
