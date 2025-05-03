-- ~/.config/nvim/lua/custom/plugins/toggleterm.lua
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

        vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>lua _LLDB_TOGGLE()<CR>", { noremap = true, silent = true })
    end,
    keys = {
        { "<leader>l", "<cmd>lua _LLDB_TOGGLE()<CR>", desc = "Toggle LLDB with current binary" }
    },
}
