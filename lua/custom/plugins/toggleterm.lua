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

        local gdb = Terminal:new({
            cmd = "gdb",
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

        function _GDB_TOGGLE()
            -- get filename from CURRENT (non-terminal) buffer
            local filename = vim.api.nvim_buf_get_name(0)
            local basename = vim.fn.fnamemodify(filename, ":t:r")  -- 'main.cpp' → 'main'
            current_exe = "./build/" .. basename

            gdb:toggle()
        end
        -- Custom command to invoke gdb in float term
        vim.api.nvim_create_user_command('Gdb', function() _GDB_TOGGLE() end, {})
        -- GDB toggle keymap
        vim.keymap.set('n', '<space>r', '<cmd>Gdb<cr>', { desc = 'Toggle GDB' })
        vim.api.nvim_create_user_command("ToggleTermCloseId", function(opts)
          local id = tonumber(opts.args)
          local t = require("toggleterm.terminal").get(id)
          if t then t:close() else vim.notify("No ToggleTerm with id "..opts.args, vim.log.levels.WARN) end
        end, { nargs = 1 })

        vim.api.nvim_create_user_command("ToggleTermShutdownId", function(opts)
          local id = tonumber(opts.args)
          local t = require("toggleterm.terminal").get(id)
          if t then t:shutdown() else vim.notify("No ToggleTerm with id "..opts.args, vim.log.levels.WARN) end
        end, { nargs = 1 })

        -- Keymaps to toggle multiple numbered terminals
        vim.keymap.set("n", "<leader>1", "<cmd>1ToggleTerm<cr>", { desc = "Toggle terminal 1" })
        vim.keymap.set("n", "<leader>2", "<cmd>2ToggleTerm<cr>", { desc = "Toggle terminal 2" })
        vim.keymap.set("n", "<leader>3", "<cmd>3ToggleTerm<cr>", { desc = "Toggle terminal 3" })
        vim.keymap.set("n", "<leader>4", "<cmd>4ToggleTerm<cr>", { desc = "Toggle terminal 4" })

        -- Open with a different direction or size per id
        vim.keymap.set("n", "<leader>v", "<cmd>2ToggleTerm direction=vertical size=50<cr>", { desc = "Vertical terminal (id=2)" })
        vim.keymap.set("n", "<leader>f", "<cmd>4ToggleTerm direction=float<cr>", { desc = "Floating terminal (id=4)" })
    end
}
