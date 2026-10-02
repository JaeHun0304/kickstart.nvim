-- ~/.config/nvim/lua/custom/plugins/grapple.lua
-- Tag a handful of working files and jump to them by slot number
return {
    'cbochs/grapple.nvim',
    dependencies = {
        { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    -- Tags are persisted per git branch (falls back to cwd outside git)
    opts = {
        scope = 'git_branch',
    },
    cmd = 'Grapple',
    keys = {
        { '<leader>ta', '<cmd>Grapple toggle<cr>',          desc = 'Grapple: tag/untag file' },
        { '<leader>tt', '<cmd>Grapple toggle_tags<cr>',     desc = 'Grapple: tags menu' },
        { '<leader>tn', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple: next tag' },
        { '<leader>tp', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple: previous tag' },
        { '<leader>1',  '<cmd>Grapple select index=1<cr>',  desc = 'Grapple: select tag 1' },
        { '<leader>2',  '<cmd>Grapple select index=2<cr>',  desc = 'Grapple: select tag 2' },
        { '<leader>3',  '<cmd>Grapple select index=3<cr>',  desc = 'Grapple: select tag 3' },
        { '<leader>4',  '<cmd>Grapple select index=4<cr>',  desc = 'Grapple: select tag 4' },
        { '<leader>5',  '<cmd>Grapple select index=5<cr>',  desc = 'Grapple: select tag 5' },
    },
}
