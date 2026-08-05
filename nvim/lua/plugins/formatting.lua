-- Formatting: Conform.nvim configuration
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true }, function(err, did_edit)
          if not err and did_edit then
            vim.notify("Formatted", vim.log.levels.INFO)
          end
        end)
      end,
      mode = { "n", "v" },
      desc = "Format",
    },
  },
  opts = {
    formatters_by_ft = {
      -- Go
      go = { "goimports", "gofmt" },

      -- Lua
      lua = { "stylua" },

      -- Web technologies
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      html = { "prettier" },

      -- PHPCS
      -- php = { "phpcs" },

      -- Shell
      sh = { "shfmt" },
      bash = { "shfmt" },

      -- Other
      rust = { "rustfmt" },
      odin = { "ols" },

      xml = { "xmlformatter"}
    },
    -- default_format_opts = {
    --   lsp_format = "fallback",
    -- },
    -- format_on_save = {
    --   timeout_ms = 500,
    --   lsp_format = "fallback",
    -- },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
