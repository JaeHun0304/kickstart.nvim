return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'linrongbin16/lsp-progress.nvim' },
  config = function()
    require('lsp-progress').setup()
    local lualine = require("lualine")
    local lsp_progress = require('lsp-progress')
    lualine.setup({
      sections = {
        lualine_c = {
          function()
            -- invoke `progress` here.
            return lsp_progress.progress()
          end,
          {
            "filename",
            path = 2,
            file_status = true,
            newfile_status = true,
            symbols = { modified = " [+]", readonly = " [-]", unnamed = "[No Name]"}
          }
        },
      },
    })
    -- listen lsp-progress event and refresh lualine
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup('lsp_progress_refresh', { clear = true }),
      pattern = "LspProgressStatusUpdated",
      callback = function() require("lualine").refresh() end,
    })
  end
}
