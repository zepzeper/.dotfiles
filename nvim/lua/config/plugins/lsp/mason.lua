return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")
    -- import mason-lspconfig
    -- local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier",
        "stylua",
        "ruff",
        "lua-language-server",
        "emmet-language-server",
        "tailwindcss-language-server",

        -- TypeScript/JavaScript
        "ts_ls",

        -- React/HTML/CSS/Tailwind
        "html",
        "cssls",

        -- Lua (for Neovim config)
        "lua_ls",

        -- PHP
        "intelephense",

        -- Go
        "gopls",
      },
    })
  end,
}
