-- ~/.config/lua/custom/keymap.lua
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- NOTE: Keymap for buffer management
-- Move to previous/next
vim.keymap.set('n', '<leader>m', '<Cmd>BufferPrevious<CR>')
vim.keymap.set('n', '<leader>.', '<Cmd>BufferNext<CR>')
vim.keymap.set('n', '<leader>d', '<Cmd>BufferDelete<CR>')
-- vim.keymap.set('n', '<leader>d', '<Cmd>bd!<CR>')

-- Pin/unpin buffer
vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>')

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

-- NOTE: Git plugins related keymaps
vim.keymap.set('n', '<leader>gn', '<cmd>Gitsigns next_hunk<CR>', { desc = 'Go to next git hunk' })
vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<CR>', { desc = 'Go to prev git hunk' })
vim.keymap.set('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>', { desc = 'Go to prev git hunk' })
vim.keymap.set('n', '<leader>gi', '<cmd>Gitsigns preview_hunk_inline<CR>', { desc = 'Preview git hunk inline' })
vim.keymap.set('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>', { desc = "Do git diff in vertical split" })
vim.keymap.set('n', '<leader>go', '<cmd>DiffviewOpen -uno<CR>', { desc = 'open diffview panel - ignore untracked files' })
vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<CR>', { desc = 'close diffview panel' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<CR>', { desc = 'open git file history' })

-- NOTE: Copy line without \n with key 'Y'
vim.keymap.set('n', 'Y', '^y$', { desc = 'Copy whole line without \n' })

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
-- NOTE: ToggleTerm shortcut
vim.keymap.set({ 'n', 't' }, '<leader>t', '<cmd>ToggleTerm direction=horizontal size=15<cr>',
    { desc = 'Toggleterm on vertical' })

-- NOTE: scroll left and right with 20 chars
vim.keymap.set('n', '<C-h>', '20zh', { desc = 'Scroll left 20 chars' })
vim.keymap.set('n', '<C-l>', '20zl', { desc = 'Scroll right 20 chars' })

-- NOTE: insert space in normal mode with <space>
vim.keymap.set('n', '<space>', 'a<space><esc>', { desc = 'Insert space in normale mode' })
vim.keymap.set('n', '<leader>ws', '<cmd>SessionSearch<CR>', { desc = 'Session search' })
vim.keymap.set('n', '<leader>wd', '<cmd>Autosession delete<CR>', { desc = 'Session search' })

-- NOTE: build with <leader> + b
vim.keymap.set('n', '<leader>b', '<cmd>make<CR>', { desc = "build with default command" })
