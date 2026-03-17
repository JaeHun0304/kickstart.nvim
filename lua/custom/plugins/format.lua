-- ~/.config/nvim/lua/custom/plugins/format.lua
return {
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    -- note: use fold with nvim-ufo
    { 'kevinhwang91/nvim-ufo', dependencies = { 'kevinhwang91/promise-async' }, opts = {} },
    -- Highlight todo, notes, etc in comments
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false },
    },
    { -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        enabled = false,
        main = 'ibl',
        opts = {},
    },
}
