-- ~/.config/nvim/lua/custom/plugins/git.lua
return {
    {
      'tpope/vim-fugitive',
    },
    {
      'sindrets/diffview.nvim',
      config = function()
        require('diffview').setup({
          -- Optional: Enhance the diff view with more colors
          enhanced_diff_hl = true,

          -- Other optional configurations
          view = {
            merge_tool = {
              layout = "diff3_mixed",
              disable_diagnostics = true,  -- Temporarily disable diagnostics for conflict buffers
            },
          },
        })
        vim.keymap.set('n', '<leader>do', '<cmd>DiffviewOpen -uno<CR>', { desc = 'open diffview panel - ignore untracked files' })
        vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<CR>', { desc = 'close diffview panel' })
        vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<CR>', { desc = 'open git file history' })
      end
    },
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup({
          signcolumn = true,     -- Yes, show signs in the sign column
          numhl      = false,    -- No number highlights
          linehl     = false,    -- No full line highlights
          word_diff  = false,    -- No word-by-word diff

          -- Disable all keymaps and actions (optional, if you want *only* signs)
          on_attach = function(bufnr)
            -- No keymaps here
          end
        })
        vim.keymap.set('n', '<leader>gn', '<cmd>Gitsigns next_hunk<CR>', { desc = 'Go to next git hunk' })
        vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<CR>', { desc = 'Go to prev git hunk' })
        vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>', { desc = 'Revert git hunk' })
        vim.keymap.set('n', '<leader>gi', '<cmd>Gitsigns preview_hunk_inline<CR>', { desc = 'Preview git hunk inline' })
        vim.keymap.set('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>', { desc = "Do git diff in vertical split" })
      end
    }
}
