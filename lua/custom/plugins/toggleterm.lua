--- ~/.config/nvim/lua/custom/plugins/toggleterm.lua
return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        local ok, toggleterm = pcall(require, "toggleterm")
        if not ok then
            return
        end

        toggleterm.setup({
            direction = "float",
            float_opts = { border = "curved" },
        })

        local Terminal = require("toggleterm.terminal").Terminal

        -- Capture executable path *before* opening terminal
        local current_exe = nil

        local lldb = Terminal:new({
            cmd = "lldb",
            hidden = true,
            direction = "float",
            float_opts = { border = "double" },
            on_open = function(term)
                if current_exe then
                    vim.fn.chansend(term.job_id, "file " .. current_exe .. "\n")
                end
                vim.cmd("startinsert!")
            end,
        })

        function _LLDB_TOGGLE()
            -- get filename from CURRENT (non-terminal) buffer
            local filename = vim.api.nvim_buf_get_name(0)
            local basename = vim.fn.fnamemodify(filename, ":t:r")  -- 'main.cpp' → 'main'
            current_exe = "./build/" .. basename

            lldb:toggle()
        end
        -- Custom command to invoke lldb in float term
        vim.api.nvim_create_user_command('Lldb', function() _LLDB_TOGGLE() end, {})
        -- LLDB toggle keymap
        vim.keymap.set('n', '<space>r', '<cmd>Lldb<cr>', { desc = 'Toggle LLDB' })
    end,
}
