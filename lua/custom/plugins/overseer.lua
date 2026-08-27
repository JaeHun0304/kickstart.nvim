return {
    -- NOTE: Task runner for concurrent jobs. Unlike asyncrun.vim (single global job,
    -- output to the shared quickfix list), overseer runs many tasks at once and gives
    -- each its own output buffer. Use :run (asyncrun) for one-shot builds you want in
    -- quickfix; use :orun (overseer) when several jobs need to be in flight together.
    {
        'stevearc/overseer.nvim',
        cmd = {
            'OverseerOpen',
            'OverseerClose',
            'OverseerToggle',
            'OverseerRun',
            'OverseerShell',
            'OverseerTaskAction',
        },
        keys = {
            { '<leader>ot', '<cmd>OverseerToggle<CR>',     desc = 'Overseer [T]oggle task list' },
            { '<leader>oo', '<cmd>OverseerOpen<CR>',       desc = 'Overseer [O]pen task list' },
            { '<leader>or', '<cmd>OverseerRun<CR>',        desc = 'Overseer [R]un template' },
            { '<leader>oc', ':OverseerShell ',             desc = 'Overseer run shell [C]ommand' },
            { '<leader>oa', '<cmd>OverseerTaskAction<CR>', desc = 'Overseer task [A]ction' },
        },
        opts = {
            -- NOTE: nvim-dap is not installed; skip the preLaunchTask/postDebugTask patching
            dap = false,

            task_list = {
                direction = 'bottom',
                min_height = 15,
                max_height = { 25, 0.3 },

                bindings = {
                    -- NOTE: <C-h/j/k/l> are window-movement keys globally, and overseer binds
                    -- them buffer-locally in the task list. Free them and move detail/scroll
                    -- onto <M-...> so window navigation still works while the list is focused.
                    ['<C-h>'] = false,
                    ['<C-j>'] = false,
                    ['<C-k>'] = false,
                    ['<C-l>'] = false,
                    ['<M-h>'] = 'DecreaseDetail',
                    ['<M-l>'] = 'IncreaseDetail',
                    ['<M-k>'] = 'ScrollOutputUp',
                    ['<M-j>'] = 'ScrollOutputDown',
                },
            },

            task_win = {
                border = 'rounded',
            },
        },
    },
}
