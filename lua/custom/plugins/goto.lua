-- ~/.config/nvim/lua/custom/plugins/goto.lua
return {
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
