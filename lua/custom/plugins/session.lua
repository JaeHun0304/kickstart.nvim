-- ~/.config/nvim/lua/custom/plugins/session.lua
return {
    -- NOTE: Plugins to save session automatically
    {
        'rmagatti/auto-session',
        lazy = false,
        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {},
        vim.keymap.set('n', '<leader>ws', '<cmd>AutoSession search<CR>', { desc = 'Session search' }),
        vim.keymap.set('n', '<leader>wd', '<cmd>AutoSession deletePicker<CR>', { desc = 'Session search' }),
    },
}
