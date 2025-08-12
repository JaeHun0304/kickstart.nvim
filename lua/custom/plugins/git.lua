-- ~/.config/nvim/lua/custom/plugins/git.lua
return {
    {
      'tpope/vim-fugitive',
      'sindrets/diffview.nvim',
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
      end
    }
}
