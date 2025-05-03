-- ~/.config/nvim/lua/custom/state_dirs.lua
local home = vim.fn.expand("~")
local state_dir = home .. "/.nvim"

-- Ensure subdirectories exist
local paths = {
    swap = state_dir .. "/swap//",
    backup = state_dir .. "/backup//",
    undo = state_dir .. "/undo//",
}

for _, path in pairs(paths) do
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
    end
end

-- Apply to Neovim options
vim.opt.directory  = paths.swap
vim.opt.backupdir  = paths.backup
vim.opt.undodir    = paths.undo
vim.opt.swapfile   = true
vim.opt.backup     = true
vim.opt.undofile   = true

