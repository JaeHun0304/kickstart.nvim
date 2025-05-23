-- ~/.config/nvim/lua/custom/settings.lua

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

--  NOTE: Expand bash aliases in neovim
vim.env.BASH_ENV = '~/.vim_bash_env'

--  NOTE: Disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Indentation settings (Lua)
vim.opt.expandtab = true    -- Use spaces instead of tabs
vim.opt.tabstop = 4         -- Number of spaces tabs count for
vim.opt.shiftwidth = 4      -- Number of spaces to use for autoindent
vim.opt.softtabstop = 4     -- Number of spaces inserted when pressing Tab
vim.opt.autoindent = true   -- Copy indent from current line when starting new line
vim.opt.smartindent = true  -- Smart autoindenting when starting a new line

--  NOTE: open quickfix window for the asyncrun plugin
vim.g.asyncrun_open = 15

--  NOTE: Set fold related settings
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.conceallevel = 2
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- NOTE: cmake to build from ./build dir
vim.opt.makeprg = 'cmake --preset default; cmake --build --preset default'

--  NOTE: For enhancing autosession experience
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- NOTE: Triger `autoread` when files changes on disk
-- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
    pattern = '*',
    command = "if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
})

-- NOTE: Notification after file change
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
    pattern = '*',
    command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

--  NOTE: Default set wrap for the diff
vim.opt.diffopt:append('followwrap')

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 300

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 500

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- using gui colors
vim.opt.termguicolors = true

-- Set wildmode for command line
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest,list,full'

-- Set completeopt
vim.opt.completeopt = 'menu,menuone,noselect'

-- Use ripgrep for vim :grep command
vim.o.grepprg = "rg --vimgrep --smart-case --color=never"
vim.o.grepformat = "%f:%l:%c:%m"

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- Custom Git push command to gerrit main
vim.api.nvim_create_user_command(
    "GitPushMain",
    function()
        vim.cmd("Git push origin HEAD:refs/for/main")
    end,
    {}
)
-- Custom Git pull command from origin/main with rebase
vim.api.nvim_create_user_command(
    "GitPullMain",
    function()
        vim.cmd("Git pull --rebase origin/main")
    end,
    {}
)
