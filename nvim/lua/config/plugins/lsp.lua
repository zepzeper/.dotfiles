return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      -- Snippets
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      local lspconfig = require("lspconfig")

      local function diagnostics_to_quickfix()
        vim.diagnostic.setqflist({ open = true })
      end

      -- Initialize lsp-zero with recommended settings
      lsp_zero.preset("recommended")

      -- Setup Mason and Mason-LSPConfig
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "html",
          "cssls",
          "rust_analyzer",
          "omnisharp",
          "intelephense",
        },
        handlers = {
          lsp_zero.default_setup,
        },
      })

      -- Define on_attach for keymaps and other settings
      lsp_zero.on_attach(function(client, bufnr)
        -- Set default keymaps
        lsp_zero.default_keymaps({ buffer = bufnr })

        -- Additional keymaps
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>i", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>qf", diagnostics_to_quickfix, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>e", vim.diagnostic.setloclist, opts)
      end)

      local function getIncludePath()
        -- Get the root directory dynamically
        local root_dir = vim.fn.getcwd()

        print("Root Directory: " .. root_dir)
        -- Add the `vendor` directory to includePaths
        return {
          root_dir .. '/_ide-helper.php',
          -- root_dir .. '/html/vendor/illuminate',
        }
      end

      -- Setup specific LSP servers with custom configurations
      lspconfig.intelephense.setup({
        cmd = { "node", "--max-old-space-size=4096", vim.fn.expand("~/.local/share/nvim/mason/bin/intelephense"), "--stdio" },
        root_dir = function(fname)
          return require("lspconfig").util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
        end,
        init_options = {
          licenseKey = vim.fn.expand("~/intelephense/license.txt"),
        },
        settings = {
          intelephense = {
            environment = {
              includePaths = getIncludePath()
            },
            files = {
              maxSize = 10000000, -- Increase file size limit to 10 MB
            },
          }
        }
      })

      lspconfig.rust_analyzer.setup({
        cmd = { "rust-analyzer" },
        root_dir = vim.loop.cwd,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              env = {
                LIBTORCH_USE_PYTORCH = "1",
                LIBTORCH_BYPASS_VERSION_CHECK = "1",
              },
            },
            diagnostics = {
              enable = true,
            },
            inlayHints = {
              enable = true,
            },
          },
        },
      })

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Finalize lsp-zero setup
      lsp_zero.setup()
    end,
  },
}
