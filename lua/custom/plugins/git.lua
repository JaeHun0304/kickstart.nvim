-- ~/.config/nvim/lua/custom/plugins/git.lua
return {
    {
      'tpope/vim-fugitive',
      'sindrets/diffview.nvim',
      "TimUntersberger/neogit",
      cmd = "Neogit",
      config = function()
        require("neogit").setup({
          kind = "split", -- opens neogit in a split 
          signs = {
            -- { CLOSED, OPENED }
          section = { "", "" },
          item = { "", "" },
          hunk = { "", "" },
          },
          integrations = { diffview = true }, -- adds integration with diffview.nvim
        })
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
      end
    }
}
