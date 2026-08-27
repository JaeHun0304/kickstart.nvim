-- ~/.config/nvim/lua/custom/plugins/nvim-tree.lua
return {
    -- NOTE: nvim-tree file explorer
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeCollapse", "NvimTreeRefresh" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
            { "<leader>ef", "<cmd>NvimTreeFindFile<cr>", desc = "Find current file in tree" },
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        -- netrw is disabled (see setting.lua), so nothing renders a directory
        -- buffer: `:e <dir>` just yields an empty "[No Name] [RO]" buffer.
        -- nvim-tree can take that over via hijack_directories, but only if it
        -- is already loaded -- and the lazy triggers above are commands/keys
        -- only, so it never loads in time. `init` runs at startup (not lazy),
        -- registering an autocmd that loads nvim-tree the first time a
        -- directory buffer is entered. Covers `:e <dir>` and `nvim <dir>`.
        init = function()
            local group = vim.api.nvim_create_augroup("NvimTreeHijackDir", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
                group = group,
                callback = function(args)
                    local path = vim.api.nvim_buf_get_name(args.buf)
                    if path ~= "" and vim.fn.isdirectory(path) == 1 then
                        vim.api.nvim_del_augroup_by_id(group)
                        require("lazy").load { plugins = { "nvim-tree.lua" } }
                        -- nvim-tree registers its own hijack autocmd during
                        -- setup, i.e. too late for the BufEnter we are already
                        -- inside. Open it here instead; current_window = true
                        -- replaces the empty directory buffer in place, the way
                        -- netrw used to.
                        require("nvim-tree.api").tree.open {
                            path = path,
                            current_window = true,
                        }
                    end
                end,
            })
        end,
        config = function()
            require("nvim-tree").setup {
                view = {
                    width = 50,
                },
                -- take over directory buffers (`:e <dir>`) and render the tree
                -- there instead of leaving an empty buffer
                hijack_directories = {
                    enable = true,
                    auto_open = true,
                },
                hijack_netrw = true,
                on_attach = function(bufnr)
                    local api = require('nvim-tree.api')
                    api.config.mappings.default_on_attach(bufnr)
                end,
                filters = {
                    git_ignored = false,
                },
            }
        end,
    }
}
