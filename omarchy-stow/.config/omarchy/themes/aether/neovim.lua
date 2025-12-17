return {
    {
        "bjarneo/aether.nvim",
        name = "aether",
        priority = 1000,
        opts = {
            disable_italics = false,
            colors = {
                -- Monotone shades (base00-base07)
                base00 = "#121212", -- Default background
                base01 = "#9e9e9e", -- Lighter background (status bars)
                base02 = "#121212", -- Selection background
                base03 = "#9e9e9e", -- Comments, invisibles
                base04 = "#ffffff", -- Dark foreground
                base05 = "#ffffff", -- Default foreground
                base06 = "#ffffff", -- Light foreground
                base07 = "#ffffff", -- Light background

                -- Accent colors (base08-base0F)
                base08 = "#d06057", -- Variables, errors, red
                base09 = "#e8a19b", -- Integers, constants, orange
                base0A = "#d58c71", -- Classes, types, yellow
                base0B = "#79bcbe", -- Strings, green
                base0C = "#68b4b6", -- Support, regex, cyan
                base0D = "#8e99c8", -- Functions, keywords, blue
                base0E = "#cd989d", -- Keywords, storage, magenta
                base0F = "#ecc4b5", -- Deprecated, brown/yellow
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
            require("aether.hotreload").setup()
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "aether",
        },
    },
}
