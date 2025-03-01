-- ~/.config/nvim/lua/custom/plugins/goto.lua
return {
  -- NOTE: Portal for the jumplist enhancements
  { 'cbochs/portal.nvim', opts = {} },

  -- NOTE: Plugins to preview LSP definition
  {
    'rmagatti/goto-preview',
    opts = {
      default_mappings = true,
    },
  },
  -- NOTE: open specific line of file
  { 'wsdjeg/vim-fetch' },
}
