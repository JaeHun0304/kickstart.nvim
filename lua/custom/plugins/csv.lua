return {
  "chrisbra/csv.vim",
  lazy = false,
  init = function()
    -- Ensure csv.vim ftplugin loads before syntax script
    vim.g.csv_no_conceal = 1
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "csv",
      callback = function(args)
        vim.treesitter.stop(args.buf)
      end,
    })
  end,
}
