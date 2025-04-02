-- ~/.config/nvim/lua/custom/plugins/session.lua
return {
    -- NOTE: Plugins to save session automatically
    {
        'rmagatti/auto-session',
        lazy = false,
        keys = {
            -- Will use Telescope if installed or a vim.ui.select picker otherwise
            { '<leader>wr', '<cmd>SessionSearch<CR>',         desc = 'Session search' },
            { '<leader>ws', '<cmd>SessionSave<CR>',           desc = 'Save session' },
            { '<leader>wa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
            { '<leader>wd', '<cmd>Autosession delete<CR>',    desc = 'Delete selected session' },
        },
        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {},
    },
}
