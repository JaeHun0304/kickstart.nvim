-- ~/.config/nvim/lua/custom/plugins/session.lua
return {
    {
        'rmagatti/auto-session',
        enabled = true,
        lazy = false,
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            auto_save = false,    -- no auto-save on exit
            auto_restore = true,  -- restore session when opening nvim in a session dir
            auto_create = false,  -- don't create session automatically
        },
        keys = {
            { '<leader>wS', '<cmd>AutoSession search<CR>',  desc = 'Session search' },
            { '<leader>ws', '<cmd>AutoSession save<CR>',    desc = 'Session save' },
            { '<leader>wd', '<cmd>AutoSession delete<CR>',  desc = 'Session delete' },
            { '<leader>wr', '<cmd>AutoSession restore<CR>', desc = 'Session restore' },
        },
    },
}
