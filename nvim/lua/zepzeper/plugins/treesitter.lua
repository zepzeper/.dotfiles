require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "go", "php", "typescript", "nix", "yaml"},
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    auto_install = true,
    indent = {
        enable = true,
    },

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },

})
