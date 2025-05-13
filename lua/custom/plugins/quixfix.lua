return {
    -- NOTE: Load kevinhwang91/promise-async
    { 'kevinhwang91/promise-async' },
    -- NOTE: Fold with nvim-ufo
    { 'kevinhwang91/nvim-ufo',     requires = 'kevinhwang91/promise-async' },
    -- NOTE: Plugin to run shell command in async quickfix window
    { 'skywind3000/asyncrun.vim' },
}
