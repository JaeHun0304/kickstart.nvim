-- ~/.config/nvim/lua/custom/plugins/nvim-tree.lua
return {
    -- NOTE: nvim-tree file explorer
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {
                view = {
                    width = 50,
                },
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
