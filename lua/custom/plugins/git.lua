-- ~/.config/nvim/lua/custom/plugins/git.lua
return {
    {
      'tpope/vim-fugitive',
      cmd = {
        'G', 'Git', 'Gvdiffsplit', 'Gdiffsplit', 'Gread', 'Gwrite',
        'Gedit', 'Gclog', 'Glgrep', 'Gblame', 'Gbrowse', 'Ggrep',
      },
      keys = {
        { '<leader>dd', '<cmd>tab Git! diff<CR>',          desc = 'git diff (unified, full tab)' },
        { '<leader>dD', '<cmd>tab Git! diff --staged<CR>', desc = 'git diff staged (full tab)' },
        { '<leader>gt', '<cmd>G ls-files --error-unmatch %<CR>', desc = 'Is current file tracked by git?' },
      },
    },
    {
      'sindrets/diffview.nvim',
      cmd = {
        'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory',
        'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh',
      },
      keys = {
        { '<leader>do', '<cmd>DiffviewOpen -uno<CR>', desc = 'open diffview panel - ignore untracked files' },
        { '<leader>dc', '<cmd>DiffviewClose<CR>',     desc = 'close diffview panel' },
        { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'open git file history (current file)' },
      },
      config = function()
        require('diffview').setup({
          -- Optional: Enhance the diff view with more colors
          enhanced_diff_hl = true,

          -- Other optional configurations
          view = {
            merge_tool = {
              layout = "diff3_vertical",
              disable_diagnostics = true,  -- Temporarily disable diagnostics for conflict buffers
            },
          },
        })
      end
    },
    {
      'lewis6991/gitsigns.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      keys = {
        { '<leader>gn', '<cmd>Gitsigns next_hunk<CR>',           desc = 'Go to next git hunk' },
        { '<leader>gp', '<cmd>Gitsigns prev_hunk<CR>',           desc = 'Go to prev git hunk' },
        { '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>',          desc = 'Revert git hunk' },
        { '<leader>gr', function() require('gitsigns').reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, mode = 'v', desc = 'Revert selected lines' },
        { '<leader>gs', function() require('gitsigns').stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, mode = 'v', desc = 'Stage selected lines' },
        { '<leader>gi', '<cmd>Gitsigns preview_hunk_inline<CR>', desc = 'Preview git hunk inline' },
        { '<leader>gb', '<cmd>Gitsigns blame<CR>',               desc = 'Git blame full file in side window' },
        { '<leader>gd', '<cmd>Gvdiffsplit<CR>',                  desc = 'Do git diff in vertical split' },
      },
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
      end
    }
}
