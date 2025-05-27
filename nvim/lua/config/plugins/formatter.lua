return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          css = { { "prettierd", "prettier" } },
          graphql = { { "prettierd", "prettier" } },
          html = { { "prettierd", "prettier" } },
          javascript = { { "prettierd", "prettier" } },
          javascriptreact = { { "prettierd", "prettier" } },
          json = { { "prettierd", "prettier" } },
          lua = { "stylua" },
          markdown = { { "prettierd", "prettier" } },
          python = { "isort", "black" },
          sql = { "sql-formatter" },
          svelte = { { "prettierd", "prettier" } },
          typescript = { { "prettierd", "prettier", "sql-formatter" } },
          typescriptreact = { { "prettierd", "prettier" } },
          yaml = { "prettier" },
          xml = { "xmlformatter" }
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_fallback = true,
          async = true,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
}
