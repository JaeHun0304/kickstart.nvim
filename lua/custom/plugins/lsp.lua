-- ~/.config/nvim/lua/custom/plugins/lsp.lua
return {
    {   -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Useful status updates for LSP.
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',       opts = {} },

            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            { 'folke/neodev.nvim',       opts = {} },
        },
        config = function()
            vim.lsp.set_log_level("off") -- Disable LSP log
            local hostname = vim.fn.hostname()
            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup({
                runtime = {
                    -- LuaJIT in the case of Neovim
                    version = 'LuaJIT',
                    path = vim.split(package.path, ';'),
                },
                diagnostics = {
                    globals = {'vim'},
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            })
            if string.find(hostname, "atletx") then
                lspconfig.clangd.setup({
                    cmd = { "/home/jaehjung/bin/clangd",
                          "--all-scopes-completion",
                          "--background-index=false",
                          "--completion-style=detailed",
                          "--header-insertion=never",
                          "--clang-tidy",
                          -- add any other options you want
                    },  -- 🛠️ Use clangd symlink in ~/bin
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                    root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"), -- Find project root
                    capabilities = require('cmp_nvim_lsp').default_capabilities(),           -- (optional) if you use nvim-cmp
                })
            elseif string.find(hostname, "Jaehuns%-Laptop") then
                lspconfig.clangd.setup({
                    cmd = { "/opt/homebrew/opt/llvm/bin/clangd",
                          "--all-scopes-completion",
                          "--background-index",
                          "--completion-style=detailed",
                          "--clang-tidy",
                          -- add any other options you want
                    },
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                    root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"), -- Find project root
                    capabilities = require('cmp_nvim_lsp').default_capabilities(),           -- (optional) if you use nvim-cmp
                })
            else
                lspconfig.clangd.setup({
                    cmd = { "/home/jaehjung/bin/clangd",
                          "--all-scopes-completion",
                          "--background-index",
                          "--completion-style=detailed",
                          "--header-insertion=never",
                          "--clang-tidy",
                          -- add any other options you want
                    },  -- 🛠️ Use clangd symlink in ~/bin
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                    root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"), -- Find project root
                    capabilities = require('cmp_nvim_lsp').default_capabilities(),           -- (optional) if you use nvim-cmp
                })
            end
            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself.
                    --
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                    -- Find references for the word under your cursor.
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('<leader>lt', require('telescope.builtin').lsp_type_definitions, '[L]sp [T]ype definition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[L]sp [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                        '[L]sp [W]orkspace symbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>lr', vim.lsp.buf.rename, '[L]sp [R]ename')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('<leader>la', vim.lsp.buf.code_action, '[L]sp code [A]ction')

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap.
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight',
                            { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end

                    -- The following autocommand is used to enable inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event.buf }
                end,
            })
        end,
    },
}
