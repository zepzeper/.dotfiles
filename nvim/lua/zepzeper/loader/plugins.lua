return {
    {
        "shortcuts/no-neck-pain.nvim",
        cmd = { "NoNeckPain" },
        config = function()
            require("zepzeper.plugins.no-neck-pain").setup()
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "VeryLazy" },
        config = function()
            require("zepzeper.plugins.indent-blankline")
        end,
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("zepzeper.plugins.oil-nvim")
        end,
        lazy = false,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = { "Telescope" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-lua/popup.nvim",
            {
                -- Currently only using these enhancements with telescope.
                "stevearc/quicker.nvim",
                config = function()
                    require("zepzeper.plugins.quicker")
                end,
            },
        },
        config = function()
            require("zepzeper.plugins.telescope")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        config = function()
            require("zepzeper.plugins.lualine")
        end,
    },
    {
        -- This plugin has issues when lazy.
        "lewis6991/gitsigns.nvim",
        -- event = { "VeryLazy" },
        config = function()
            require("zepzeper.plugins.gitsigns")
        end,
        lazy = false,
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewClose", "DiffviewOpen" },
        config = function()
            require("zepzeper.plugins.diffview")
        end,
    },
    {
        "f-person/git-blame.nvim",
        config = function()
            require("zepzeper.plugins.git-blame")
        end,
    },
    -- Language.
    {
        "mfussenegger/nvim-lint",
        -- Does not make sense to have a linter without a LSP.
        -- This will have to change if that ever happens.
        -- event = { "LspAttach" },
        lazy = false,
        config = function()
            require("zepzeper.plugins.linter")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        event = { "VeryLazy" },
        build = { ":TSUpdate" },
        config = function()
            require("zepzeper.plugins.treesitter")
        end,
    },
    {
        "folke/lazydev.nvim",
        dependencies = { "Bilal2453/luvit-meta" },
        ft = "lua",
        event = { "LspAttach" },
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "VeryLazy" },
        config = function()
            require("zepzeper.plugins.completion")
        end,
        dependencies = {
            "hrsh7th/cmp-omni",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            {
                "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
                build = "make install_jsregexp",
            },
        },
    },
    -- Dependencies.
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            require("zepzeper.plugins.nvim-web-devicons")
        end,
    },
    {
        -- Loaded by the native config.
        "neovim/nvim-lspconfig",
        lazy = true,
    },

    -- Themes.
    {
        "AlexvZyl/nordic.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("zepzeper.plugins.nordic")
        end,
    },

    -- Bin (maybe to remove)
    {
        "folke/which-key.nvim",
        event = { "VeryLazy" },
        config = function()
            require("zepzeper.plugins.which-key")
        end,
    },
    {
        "NeogitOrg/neogit",
        dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
        config = function()
            require("zepzeper.plugins.neogit")
        end,
    },
    {
        "ThePrimeagen/99",
        config = function()
            require("zepzeper.plugins.99")
        end,
    },
    {
        "zepzeper/zemac",
        dir = "~/personal/zemac",
        config = function()
            require("zepzeper.plugins.zemac")
        end,
    },
}
