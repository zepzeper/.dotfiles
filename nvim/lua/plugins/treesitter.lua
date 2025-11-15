return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "go",
                    "gomod",
                    "gosum",
                    "javascript",
                    "typescript",
                    "tsx",
                    "lua",
                    "php",
                    "phpdoc",
                    "html",
                    "swift",
                    "css",      -- for Tailwind support
                    "scss",     -- optional, but good with Tailwind
                    "json",     -- often useful in JS/TS projects
                    "yaml",     -- for configs
                    "markdown", -- good for docs and READMEs
                },
                auto_install = true,
                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    }
}
