-- ~/.config/lua/custom/keymap.lua
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- NOTE: Copy line without \n with key 'Y'
vim.keymap.set('n', 'Y', '^y$', { desc = 'Copy whole line without \n' })

-- NOTE: abbreviate "vert sb" into vsb
vim.cmd 'cnorea vsb vert sb'

-- NOTE: quickfix related keymap
vim.keymap.set('n', '<leader>q', '<cmd>copen 15<CR>', { desc = 'Open quickfix window' })
vim.keymap.set('n', '<leader>Q', '<cmd>cclose<CR>', { desc = 'Close quickfix window' })
vim.keymap.set('n', '<leader>qd', '<cmd>cexpr []<CR>', { desc = 'Delete quickfix list' })
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>', { desc = 'go to next quickfix item' })
vim.keymap.set('n', '<C-p>', '<cmd>cprev<CR>', { desc = 'go to prev quickfix item' })
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- NOTE: Copy current buffer filename
vim.keymap.set('n', '<leader>yf', '<cmd>let @+ = expand("%:t") . ":" . line(".")<CR>',
    { desc = 'copy current buffer file name (just file name)' })
vim.keymap.set('n', '<leader>yF', '<cmd>let @+ = expand("%:p")<CR>',
    { desc = 'copy current buffer file name (full path)' })

-- NOTE: Toggle nvim-tree
vim.keymap.set('n', '<leader>nt', '<cmd>NvimTreeToggle<CR>', { desc = 'toggle nvim tree window' })

-- NOTE: shortcuts
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>h', '^', { desc = 'Go to first non-blank character of the line' })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>l', 'g_', { desc = 'Go to last non-blank character of the line' })
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>', { desc = 'Select all text in buffer' })

-- NOTE: Commands
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save buffer' })

-- NOTE: Move windows with C-hjkl
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'move cursor to left window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'move cursor to right window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'move cursor to lower window'})
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'move cursor to upper window'})

-- NOTE: insert space in normal mode with <space>
vim.keymap.set('n', '<space>', 'a<space><esc>', { desc = 'Insert space in normale mode' })

-- NOTE: build with <leader> + b
vim.keymap.set('n', '<leader>b', '<cmd>make<CR>', { desc = "build with default command" })
