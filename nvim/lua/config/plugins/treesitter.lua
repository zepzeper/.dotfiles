return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
        -- enable indentation
        indent = { enable = true },
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
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-S-space>",
            node_incremental = "<C-S-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  }
}
