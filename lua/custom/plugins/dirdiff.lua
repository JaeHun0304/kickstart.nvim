-- ~/.config/nvim/lua/custom/plugins/dirdiff.lua
return {
    'will133/vim-dirdiff',
    config = function()
        vim.g.DirDiffExcludes = "*.o,*.d,*.so,*.time,.git,.svn,.claude,.cache,build,*.pyc,compile_commands.json"
    end,
}
