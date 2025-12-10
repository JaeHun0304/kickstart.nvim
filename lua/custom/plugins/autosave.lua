-- ~/.config/nvim/lua/custom/plugins/autosave.lua
return {
    "Pocco81/auto-save.nvim",
    config = function()
        require("auto-save").setup {
            -- your config goes here
            -- or just leave it empty :)
        }
    end
}
