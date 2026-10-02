-- ~/.config/nvim/lua/custom/plugins/dropbar.lua
-- Winbar breadcrumbs (Namespace > Class > function) for the symbol under the cursor.
-- C++ symbols come from clangd document symbols; no cpp treesitter parser is installed.
return {
  {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('dropbar').setup({})
      local api = require('dropbar.api')
      vim.keymap.set('n', '<leader>;', api.pick, { desc = 'Pick breadcrumb symbol' })
      vim.keymap.set('n', '[;', api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', api.select_next_context, { desc = 'Select next context' })
    end,
  },
}
