return {
  "chrisbra/csv.vim",
  -- Not lazy-loaded on ft: Neovim's own ftplugin/csv.vim would then be sourced
  -- first and set b:did_ftplugin, which makes this plugin's ftplugin finish
  -- early, leaving b:col unset and its syntax script warning about it.
  lazy = false,
  init = function()
    vim.g.csv_no_conceal = 1
    -- Claim these directly, so Neovim does not first detect ft=tsv and then let
    -- the plugin's ftdetect switch it to csv: that second pass sources the csv
    -- syntax script before the csv ftplugin.
    vim.filetype.add({ extension = { tsv = 'csv', tab = 'csv' } })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "csv",
      callback = function(args)
        vim.treesitter.stop(args.buf)
      end,
    })
  end,
}
