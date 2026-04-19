require("nvim-treesitter").setup({
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    indent = { enable = true },
})

vim.api.nvim_create_autocmd({'BufReadPost', 'BufNewFile'}, {
    callback = function()
        vim.treesitter.start()
    end,
})
