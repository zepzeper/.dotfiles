return {
    { "nvim-tree/nvim-web-devicons", opts = {} },
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
    {
        "hrsh7th/nvim-cmp",
        event = { "VeryLazy" },
        config = function()
            require("zepzeper.plugins.completion")
        end,
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'hrsh7th/cmp-nvim-lsp-signature-help',
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
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
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
        end
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
            'nvim-telescope/telescope-ui-select.nvim',
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
    {
        "FabijanZulj/blame.nvim",
    },
    {
        "tpope/vim-surround"
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
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
    -- {
    --     "rose-pine/neovim",
    --     name = "rose-pine",
    --     config = function()
    --         vim.cmd("colorscheme rose-pine")
    --         vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --         vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    --     end
    -- },
    -- git
    {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim", 
            "sindrets/diffview.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
        }
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "olimorris/neotest-phpunit",
        },
        config = function()
            require("zepzeper.plugins.neotest")
        end,
    },
    {
        'FabijanZulj/blame.nvim',
        lazy = false,
        config = function()
            require('blame').setup {}
        end,
    },
    {
        "jiaoshijie/undotree",
        keys = {
            { "<BS>u", "<cmd>lua require('undotree').toggle()<cr>" },
        },
    },
    {
        'tomiis4/Hypersonic.nvim',
        event = "CmdlineEnter",
        cmd = "Hypersonic",
        config = function()
            require('hypersonic').setup({
            })
        end
    },
    -- Personal
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
    {
        "vzze/cmdline.nvim",
        config = function()
            require('cmdline').setup()
        end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {},
        config = function()
            require('render-markdown').setup({ latex = { enabled = false } })
        end,
    }
}
