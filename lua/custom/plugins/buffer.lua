-- ~/.config/nvim/lua/custom/plugins/bufferline.lua
return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = false,
        offsets = { { filetype = "NvimTree", text = "Explorer", highlight = "Directory", separator = true } },
      },
    },
    keys = {
      { "<leader>bp", "<Cmd>BufferLinePick<CR>", desc = "Pick buffer" },
      { "<leader>.", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<leader>m", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<leader>bb", "<Cmd>BufferLineTogglePin<CR>", desc = "Pin buffer" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close others" },
    },
  },
  {
    "ojroques/nvim-bufdel",
    keys = {
      { "<leader>bd", "<Cmd>BufDel<CR>", desc = "Delete buffer keep layout" },
    },
    opts = { next = "alternate", quit = false },
  },
}
