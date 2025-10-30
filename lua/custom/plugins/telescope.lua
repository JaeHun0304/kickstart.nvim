-- ~/.config/nvim/lua/custom/plugins/telescope.lua
return {
    -- NOTE: Plugins can specify dependencies.
    --
    -- The dependencies are proper plugin specifications as well - anything
    -- you do for a plugin at the top level, you can do for a dependency.
    --
    -- Use the `dependencies` key to specify the dependencies of a particular plugin

    { -- Fuzzy Finder (files, lsp, etc)
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        -- Pull in rolling release for now. Once settled, try new stable version later
        -- branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'junegunn/fzf',
            'fannheyward/telescope-coc.nvim',
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                'nvim-telescope/telescope-fzf-native.nvim',

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = 'make',

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
            -- Support to pass ripgrep args into telescope
            {
                'nvim-telescope/telescope-live-grep-args.nvim',
                -- This will not install any breaking changes.
                -- For major updates, this must be adjusted manually.
                version = '^1.1.0',
            }
        },
        config = function()
            -- Telescope is a fuzzy finder that comes with a lot of different things that
            -- it can fuzzy find! It's more than just a "file finder", it can search
            -- many different aspects of Neovim, your workspace, LSP, and more!
            --
            -- The easiest way to use Telescope, is to start by doing something like:
            --  :Telescope help_tags
            --
            -- After running this command, a window will open up and you're able to
            -- type in the prompt window. You'll see a list of `help_tags` options and
            -- a corresponding preview of the help.
            --
            -- Two important keymaps to use while in Telescope are:
            --  - Insert mode: <c-/>
            --  - Normal mode: ?
            --
            -- This opens a window that shows you all of the keymaps for the current
            -- Telescope picker. This is really useful to discover what Telescope can
            -- do as well as how to actually do it!

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            local lga_actions = require 'telescope-live-grep-args.actions'
            require('telescope').setup {
                -- You can put your default mappings / updates / etc. in here
                --  All the info you're looking for is in `:help telescope.setup()`
                defaults = {
                    layout_strategy = 'flex',
                    mappings = {
                        n = {
                            ['d'] = require('telescope.actions').delete_buffer,
                        },
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                    },
                    file_ignore_patterns = {".git/", ".svn/", ".cache/", "%.o", "%.d"}
                },

                pickers = {
                    find_files = {
                        hidden = true,
                        no_ignore = true,
                        find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
                    },
                },

                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ['<Tab>'] = lga_actions.quote_prompt({}),
                                ['<C-c>'] = lga_actions.quote_prompt({ postfix = " -tcpp" }),
                                ['<C-t>'] = lga_actions.quote_prompt({ postfix = " -tconfig" }),
                            },
                        },
                    },
                    coc = {
                        theme = 'ivy',
                        prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
                        push_cursor_on_edit = true, -- save the cursor position to jump back in the future
                        timeout = 3000, -- timeout for coc commands
                    },
                },
            }

            -- Enable Telescope extensions if they are installed
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')
            pcall(require('telescope').load_extension, 'live_grep_args')
            pcall(require('telescope').load_extension, 'coc')

            -- See `:help telescope.builtin`
            local builtin = require 'telescope.builtin'
            local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files,
                { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', live_grep_args_shortcuts.grep_word_under_cursor,
                { desc = '[S]earch current [W]ord' })
            vim.keymap.set('v', '<leader>sv', live_grep_args_shortcuts.grep_visual_selection,
                { desc = '[S]earch current [V]isual Selection' })
            vim.keymap.set('n', '<leader>sg',
                "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
                { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sc',
                function() builtin.live_grep({ type_filter = "cpp", }) end,
                { desc = '[S]earch by [G]rep cpp code' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sj', builtin.jumplist, { desc = '[S]earch [J]umplist' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>lw', builtin.lsp_dynamic_workspace_symbols, { desc = 'Find from workspace symbols' })
            vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'LSP: go to definition' })
            vim.keymap.set('n', 'gr', builtin.lsp_references, { desc ='LSP: go to references' })

            -- Slightly advanced example of overriding default behavior and theme
            vim.keymap.set('n', '<leader>/', function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            -- Info: Git status only with changed files, disable untracked files
            -- Please see telescope.builtin.git_status for details
            vim.keymap.set('n', '<leader>gs', function()
                builtin.git_status {
                    expand_dir = false,
                }
            end, { desc = 'Telescope git_status for changed files' })

            vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Telescope git_commits log history' })

            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            vim.keymap.set('n', '<leader>s/', function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = '[S]earch [/] in Open Files' })

            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set('n', '<leader>sn', function()
                builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end, { desc = '[S]earch [N]eovim files' })
        end,
    },
}
