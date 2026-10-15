-- ~/.config/nvim/lua/custom/plugins/treesitter.lua
-- nvim-treesitter `main` branch: a full rewrite of the old `master` branch (see treesitter.lua.bak).
-- Needs Neovim 0.12+, `tree-sitter` CLI >= 0.26.1, tar, curl and a C compiler. It does not support lazy-loading.
-- Highlighting is no longer automatic: it is started per buffer in the FileType autocmd below.
-- Folds: nvim-ufo falls back to treesitter on its own. Indent: left to the filetype default (the plugin's
-- indentexpr is experimental); opt in per filetype with
--   vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
return {
    -- Show function/class context at top of window when scrolling
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {
            enable = true,
            max_lines = 3,
            min_window_height = 20,
            mode = 'cursor',
        },
    },

    -- Parsers, queries and highlighting helpers
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            -- The official tree-sitter CLI needs a newer glibc than these hosts have, so it is built
            -- with `cargo install tree-sitter-cli` into ~/.cargo/bin.
            local cargo_bin = vim.fn.expand('~/.cargo/bin')
            if not vim.env.PATH:find(cargo_bin, 1, true) then
                vim.env.PATH = cargo_bin .. ':' .. vim.env.PATH
            end

            local ts = require('nvim-treesitter')
            ts.setup({})

            -- Async and a no-op for parsers that are already installed.
            if vim.fn.executable('tree-sitter') == 1 then
                ts.install({ 'bash', 'c', 'cpp', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'query', 'vim', 'vimdoc' })
            else
                vim.notify('nvim-treesitter: `tree-sitter` CLI not found in PATH; parsers will not be installed', vim.log.levels.WARN)
            end

            local function start(buf, ft)
                if not vim.api.nvim_buf_is_valid(buf) or vim.treesitter.highlighter.active[buf] then
                    return
                end
                local lang = vim.treesitter.language.get_lang(ft)
                if not lang or not pcall(vim.treesitter.language.add, lang) then
                    return -- no parser installed for this filetype
                end
                -- Skip very large files (e.g. generated sources); parsing them is slow.
                local lines = vim.api.nvim_buf_line_count(buf)
                if vim.api.nvim_buf_get_offset(buf, lines) > 2 * 1024 * 1024 then
                    return
                end
                pcall(vim.treesitter.start, buf, lang)
            end

            local group = vim.api.nvim_create_augroup('custom_treesitter_start', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                group = group,
                callback = function(args) start(args.buf, args.match) end,
            })
            -- A file buffer that ends up with no filetype (seen at startup / session restore; `:e %` fixed it)
            -- gets neither syntax nor treesitter colors. Run detection for it, then start treesitter.
            local function fix(buf)
                if not vim.api.nvim_buf_is_loaded(buf) or vim.bo[buf].buftype ~= '' then
                    return
                end
                if vim.bo[buf].filetype == '' and vim.api.nvim_buf_get_name(buf) ~= '' then
                    vim.api.nvim_buf_call(buf, function() vim.cmd('filetype detect') end)
                end
                if vim.bo[buf].filetype ~= '' then
                    start(buf, vim.bo[buf].filetype)
                end
            end
            vim.api.nvim_create_autocmd({ 'VimEnter', 'SessionLoadPost' }, {
                group = group,
                callback = function()
                    vim.schedule(function()
                        for _, b in ipairs(vim.api.nvim_list_bufs()) do fix(b) end
                    end)
                end,
            })
            vim.api.nvim_create_autocmd('BufWinEnter', {
                group = group,
                callback = function(args) vim.schedule(function() fix(args.buf) end) end,
            })
        end,
    },
}
