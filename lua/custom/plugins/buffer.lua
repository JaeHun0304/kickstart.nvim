-- ~/.config/nvim/lua/custom/plugins/buffer.lua
vim.keymap.set('n', '<leader>.', '<Cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>m', '<Cmd>bprevious<CR>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<leader>bp', function()
  require('telescope.builtin').buffers()
end, { desc = 'Pick buffer' })
vim.keymap.set('n', '<leader>bo', function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_get_option(buf, 'buflisted') then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end, { desc = 'Close other buffers' })

return {
  {
    'ojroques/nvim-bufdel',
    keys = {
      { '<leader>bd', '<Cmd>BufDel<CR>', desc = 'Delete buffer keep layout' },
    },
    opts = { next = 'alternate', quit = false },
  },
}
