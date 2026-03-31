return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
        },
        build = { ":TSUpdate" },
        config = function()
            require("zepzeper.plugins.treesitter")
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "VeryLazy" },
        config = function()
            require("zepzeper.plugins.completion")
        end,
        dependencies = {
            'nvim-telescope/telescope.nvim',
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
    {
        -- Loaded by the native config.
        "neovim/nvim-lspconfig",
        lazy = true,
    },
    {
        'nvim-telescope/telescope.nvim', version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- optional but recommended
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            require("zepzeper.plugins.telescope")
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    -- Themes.
    {
        "vague-theme/vague.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("vague")
        end
    },
    -- git
    {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
        }
    },
    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",
        -- Because of the keys part, you will be lazy loading this plugin.
        -- The plugin will only load once one of the keys is used.
        -- If you want to load the plugin at startup, add something like event = "VeryLazy",
        -- or lazy = false. One of both options will work.
        opts = {
            -- your configuration comes here
            -- for example
            enabled = true,  -- if you want to enable the plugin
            message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
            date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
            virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
        },
    },
    -- Personal
    {
        "zepzeper/zemac",
        dir = "~/personal/zemac",
        config = function()
            require("zepzeper.plugins.zemac")
        end,
    },
    {
        "zepzeper/bicycle",
        dir = "~/personal/bicycle",
        name = "bicycle",
        dev = true,
        config = function()
            require("zepzeper.plugins.bicycle")
        end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {},
    }
}
