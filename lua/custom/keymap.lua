-- ~/.config/lua/custom/keymap.lua
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- NOTE: Keymap for buffer management
-- Move to previous/next
vim.keymap.set('n', '<leader>m', '<Cmd>BufferPrevious<CR>')
vim.keymap.set('n', '<leader>.', '<Cmd>BufferNext<CR>')
vim.keymap.set('n', '<leader>d', '<Cmd>BufferClose<CR>')

-- Pin/unpin buffer
vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>')

-- Magic buffer-picking mode
vim.keymap.set('n', '<C-p>', '<Cmd>BufferPick<CR>')
vim.keymap.set('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>')

-- Sort automatically by...
vim.keymap.set('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>')
vim.keymap.set('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>')
vim.keymap.set('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>')
vim.keymap.set('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>')
vim.keymap.set('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>')

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

-- NOTE: Gitsign related keymaps
vim.keymap.set('n', '<leader>gn', '<cmd>Gitsigns next_hunk<CR>', { desc = 'Go to next git hunk' })
vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<CR>', { desc = 'Go to prev git hunk' })
vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>', { desc = 'Reset current hunk on cursor' })
vim.keymap.set('n', '<leader>gd', '<cmd>Gitsigns diffthis vertical=true<CR>',
    { desc = 'Vertical diff against latest commit' })
vim.keymap.set('n', '<leader>gi', '<cmd>Gitsigns preview_hunk_inline<CR>', { desc = 'preview git hunk in line' })

-- NOTE: Neogit keymaps
vim.keymap.set('n', '<leader>ng', '<cmd>Neogit<CR>', { desc = 'Open neogit' })

-- NOTE: Copy line without \n with key 'Y'
vim.keymap.set('n', 'Y', '^y$', { desc = 'Copy whole line without \n' })

-- NOTE: Open lsp definitions in split
vim.keymap.set('n', 'gv', '<cmd> vsplit | lua vim.lsp.buf.definition()<CR>', { desc = 'Open LSP definition on vsplit' })
vim.keymap.set('n', 'gs', '<cmd> belowright split | lua vim.lsp.buf.definition()<CR>',
    { desc = 'Open LSP definition on split' })

-- NOTE: Portal keymap for the jumplist
vim.keymap.set('n', '<leader>o', '<cmd>Portal jumplist backward<cr>', { desc = 'Portal jumplist backward' })
vim.keymap.set('n', '<leader>i', '<cmd>Portal jumplist forward<cr>', { desc = 'Portal jumplist forward' })

-- NOTE: Diffview related keymaps
vim.keymap.set('n', '<leader>do', '<cmd>DiffviewOpen<CR>', { desc = 'Open diffview panel' })
vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<CR>', { desc = 'Close diffview panel' })

-- NOTE: abbreviate "vert sb" into vsb
vim.cmd 'cnorea vsb vert sb'

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

-- NOTE: quickfix related keymap
vim.keymap.set('n', '<leader>q', '<cmd>copen 15<CR>', { desc = 'Open quickfix window' })
vim.keymap.set('n', '<leader>Q', '<cmd>cclose<CR>', { desc = 'Close quickfix window' })
vim.keymap.set('n', '<leader>qd', '<cmd>cexpr []<CR>', { desc = 'Delete quickfix list' })
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>', { desc = 'go to next quickfix item' })
vim.keymap.set('n', '<C-p>', '<cmd>cprev<CR>', { desc = 'go to prev quickfix item' })
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- NOTE: Copy current buffer filename
vim.keymap.set('n', '<leader>yf', '<cmd>let @+ = expand("%:t")<CR>',
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
-- NOTE: ToggleTerm shortcut
vim.keymap.set({ 'n', 't' }, '<leader>t', '<cmd>ToggleTerm direction=horizontal size=25<cr>',
    { desc = 'Toggleterm on vertical' })

-- NOTE: scroll left and right with 20 chars
vim.keymap.set('n', '<C-h>', '20zh', { desc = 'Scroll left 20 chars' })
vim.keymap.set('n', '<C-l>', '20zl', { desc = 'Scroll right 20 chars' })

-- NOTE: insert space in normal mode with <space>
vim.keymap.set('n', '<space>', 'a<space><esc>', { desc = 'Insert space in normale mode' })
