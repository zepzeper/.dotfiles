return {
    -- Colorscheme
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        config = function()
            require("zepzeper.plugins.colorscheme")
        end,
    },

    -- Core UI
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
    },
    { "mason-org/mason.nvim", opts = {} },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
        },
        build = ":TSUpdate",
        branch = "main",
        config = function()
            require("zepzeper.plugins.treesitter")
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        lazy = true,
    },
    {
        "nvimtools/none-ls.nvim",
        config = function()
            require("zepzeper.plugins.nonels")
        end,
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        event = { "VeryLazy" },
        config = function()
            require("zepzeper.plugins.completion")
        end,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp-signature-help",
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

    -- Fuzzy finder
    {
        "dmtrKovalenko/fff.nvim",
        build = function()
            require("fff.download").download_or_build_binary()
        end,
        lazy = false,
        config = function()
            require("zepzeper.plugins.fff")
        end,
    },

    -- LSP picker
    {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleToggle" },
        config = function()
            require("zepzeper.plugins.trouble")
        end,
    },

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            {
                "igorlfs/nvim-dap-view",
                opts = {},
            },
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = {
                    "williamboman/mason.nvim",
                },
            },
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            require("zepzeper.plugins.dap")
        end,
    },

    -- Testing
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "antoinemadec/FixCursorHold.nvim",
            "olimorris/neotest-phpunit",
            "praem90/neotest-docker-phpunit.nvim",
        },
        config = function()
            require("zepzeper.plugins.neotest")
        end,
    },

    -- Git
    {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
        },
        cmd = "Neogit",
        config = function()
            require("zepzeper.plugins.neogit")
        end,
    },
    {
        "FabijanZulj/blame.nvim",
        lazy = false,
        config = function()
            require("zepzeper.plugins.blame")
        end,
    },

    -- Editor UX
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    { "tpope/vim-surround" },
    {
        "jiaoshijie/undotree",
        module = "undotree",
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        config = function()
            require("zepzeper.plugins.render-markdown")
        end,
    },

    -- Tools
    {
        "kopecmaciej/vi-sql.nvim",
        cmd = { "ViSQL", "ViSQLJump" },
        config = function()
            require("zepzeper.plugins.vi-sql")
        end,
    },
    {
        "nvim-orgmode/orgmode",
        event = "VeryLazy",
        ft = { "org" },
        config = function()
            require("zepzeper.plugins.orgmode")
        end,
    },

    -- Disabled themes
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    --     config = function()
    --         require("catppuccin").setup({
    --             flavour = "macchiato",
    --             transparent_background = true,
    --         })
    --         vim.cmd.colorscheme("catppuccin")
    --     end,
    -- },
    -- {
    --     "nyoom-engineering/oxocarbon.nvim",
    --     config = function()
    --         vim.opt.background = "dark"
    --         vim.cmd("colorscheme oxocarbon")
    --         vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --         vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    --         vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    --     end,
    -- },
    -- {
    --     "vague-theme/vague.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd.colorscheme("vague")
    --     end,
    -- },

    -- Disabled personal plugins
    -- {
    --     "zepzeper/zemac",
    --     dir = "~/personal/zemac",
    --     config = function()
    --         require("zepzeper.plugins.zemac")
    --     end,
    -- },
    -- {
    --     "zepzeper/bicycle",
    --     dir = "~/personal/bicycle",
    --     name = "bicycle",
    --     dev = true,
    --     config = function()
    --         require("zepzeper.plugins.bicycle")
    --     end,
    -- },
    -- {
    --     "zepzeper/regexplain",
    --     config = function()
    --         require("regexplain").setup()
    --     end,
    -- },
}
