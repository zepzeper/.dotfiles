local function getIncludePath()
  -- Get the root directory dynamically
  local root_dir = vim.fn.getcwd()

  print("Root Directory: " .. root_dir)
  -- Add the `vendor` directory to includePaths
  return {
    root_dir .. '/html/vendor/',
  }
end

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap -- for conciseness

        local opts = { noremap = true, silent = true }
        local on_attach = function(client, bufnr)
            opts.buffer = bufnr

            -- set keybinds
            opts.desc = "Show LSP references"
            keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

            opts.desc = "Go to declaration"
            keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

            opts.desc = "Show LSP definitions"
            keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

            opts.desc = "Show LSP implementations"
            keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

            opts.desc = "Show LSP type definitions"
            keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

            opts.desc = "See available code actions"
            keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

            opts.desc = "Smart rename"
            keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

            opts.desc = "Show buffer diagnostics"
            keymap.set("n", "<leader>E", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

            opts.desc = "Show line diagnostics"
            keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts) -- show diagnostics for line

            opts.desc = "Go to previous diagnostic"
            keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

            opts.desc = "Go to next diagnostic"
            keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

            opts.desc = "Restart LSP"
            keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
        end

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- configure html server
        lspconfig["html"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {"html", "twig"}
        })

        -- configure css server
        lspconfig["cssls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {"css"}
        })

        -- configure js server
        lspconfig["eslint"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {"js"}
        })

        -- configure tailwindcss server
        lspconfig["tailwindcss"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {"twig"}
        })

        -- configure htmx server
        lspconfig["htmx"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {"twig"}
        })


        lspconfig.rust_analyzer.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = {"rust"},
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = {
                command = "clippy",
              },
              cargo = {
                allFeatures = true,
              },
              procMacro = {
                enable = true,
              },
            },
          },
        })

        lspconfig["gopls"].setup({
            cmd = { "/etc/profiles/per-user/zepzeper/bin/gopls" },
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    -- Additional gopls-specific settings can be added here
                    diagnosticsDelay = "500ms",
                    experimentalPostfixCompletions = true,
                    usePlaceholders = true,
                    completeUnimported = true,
                }
            },
            filetypes = {"go", "gomod", "gowork"},
            root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git")
        })

        -- configure emmet language server
        lspconfig["emmet_language_server"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "twig" },
        })

        lspconfig["phpactor"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {"php"},
            cmd = { "phpactor", "language-server", "--memory-limit=2G" },
             -- Set explicit environment variables with exact paths
            settings = {
                phpactor = {
                    -- Enhance symbol provider
                    symbol = {
                        search_depth = 5
                    }
                }
            }
        })

         -- Enhanced Intelephense setup (more like PhpStorm)
        lspconfig["intelephense"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {"php"},
            cmd = { "node", "--max-old-space-size=4096", vim.fn.expand("~/.local/share/nvim/mason/bin/intelephense"), "--stdio" },
            root_dir = function(fname)
              return require("lspconfig").util.find_git_ancestor(fname) or vim.fn.getcwd()
            end,
            init_options = {
              licenseKey = vim.fn.expand("~/intelephense/license.txt"),
              -- Enable more detailed analysis
              clearCache = true,
              storagePath = vim.fn.expand("~/.local/share/intelephense"),
            },
            settings = {
              intelephense = {
                environment = {
                    includePaths = getIncludePath()
                },
                files = {
                  maxSize = 10000000, -- Increase file size limit to 10 MB
                  exclude = {
                    "**/.git/**",
                    "**/node_modules/**",
                    "**/vendor/**/*.test.php", -- Exclude test files from analysis for better performance
                  }
                },
                completion = {
                  insertUseDeclaration = true,   -- Auto-insert use statements (like PHPStorm)
                  fullyQualifyGlobalConstantsAndFunctions = false,
                  triggerParameterHints = true,
                  maxItems = 100,
                },
                format = {
                  enable = true   -- Enable formatting
                },
                diagnostics = {
                  enable = true,
                  run = "onType",  -- Run diagnostics as you type (like PHPStorm)
                },
                stubs = {
                  "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core",
                  "ctype", "curl", "date", "dba", "dom", "enchant", "exif",
                  "fileinfo", "filter", "fpm", "ftp", "gd", "gettext", "gmp",
                  "hash", "iconv", "imap", "intl", "json", "ldap", "libxml",
                  "mbstring", "meta", "mysqli", "oci8", "odbc", "openssl",
                  "pcntl", "pcre", "PDO", "pdo_ibm", "pdo_mysql", "pdo_pgsql",
                  "pdo_sqlite", "pgsql", "Phar", "posix", "pspell", "readline",
                  "reflection", "session", "shmop", "SimpleXML", "snmp", "soap",
                  "sockets", "sodium", "SPL", "sqlite3", "standard", "superglobals",
                  "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer", "xml",
                  "xmlreader", "xmlrpc", "xmlwriter", "xsl", "Zend OPcache",
                  "zip", "zlib"
                },
                telemetry = {
                  enable = false
                },
                -- Add common PHP frameworks stubs
                phpdoc = {
                  useFullyQualifiedNames = false
                }
              }
            }
          })

        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = { -- custom settings for lua
                Lua = {
                    -- make the language server recognize "vim" global
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- make language server aware of runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
    end,
}
