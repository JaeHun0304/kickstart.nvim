return {
    -- NOTE: Load kevinhwang91/promise-async
    { 'kevinhwang91/promise-async' },
    -- NOTE: Fold with nvim-ufo
    { 'kevinhwang91/nvim-ufo',     requires = 'kevinhwang91/promise-async' },
    -- NOTE: Plugin for enhanced quickfix window
    { 'kevinhwang91/nvim-bqf',     ft = 'qf' },
    -- NOTE: Plugin to run shell command in async quickfix window
    { 'skywind3000/asyncrun.vim' },
}
