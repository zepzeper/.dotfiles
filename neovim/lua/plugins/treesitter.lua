return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "go",
          "gomod",
          "gosum",
          "javascript",
          "typescript",
          "tsx",
          "lua",
          "php",
          "phpdoc",
          "html",
          "css",      -- for Tailwind support
          "scss",     -- optional, but good with Tailwind
          "json",     -- often useful in JS/TS projects
          "yaml",     -- for configs
          "markdown", -- good for docs and READMEs
        },
        highlight = { enable = true },
        indent = { enable = true, disable = { 'python' } },
      })
    end,
  }
}
