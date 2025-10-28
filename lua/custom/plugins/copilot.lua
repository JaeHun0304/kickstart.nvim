-- ~/.config/nvim/lua/custom/plugins/copilot.lua
return {
  {
    "github/copilot.vim",
    event = "InsertEnter", -- load on first insert to keep startup fast
    config = function()
      -- Optional: don’t let Copilot take over <Tab>
      vim.g.copilot_no_tab_map = true

      -- Example accept mapping (Ctrl-l)
      vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false,
        silent = true,
      })

      -- Optional: quick next/prev suggestion
      vim.keymap.set("i", "<M-]>", '<Plug>(copilot-next)', { silent = true })
      vim.keymap.set("i", "<M-[>", '<Plug>(copilot-previous)', { silent = true })

      -- Optional: dismiss suggestion
      vim.keymap.set("i", "<C-]>", '<Plug>(copilot-dismiss)', { silent = true })

      -- Optional: enable/disable per filetype
      -- Enable everywhere:
      -- vim.g.copilot_filetypes = { ["*"] = true }
      -- Or disable by default, enable selectively:
      -- vim.g.copilot_filetypes = { ["*"] = false, markdown = true, gitcommit = true, lua = true, python = true }
    end,
  },
}
