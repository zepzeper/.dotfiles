return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "javascript", "typescript", "php", "phpdoc", "lua", "rust", "html", "tsx", "go" },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        indent = { enable = true },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        modules = {},
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require'treesitter-context'.setup({
        enable = true,               -- Enable context plugin
        max_lines = 0,               -- Show as much context as possible
        trim_scope = true,           -- Trim unnecessary lines
        min_window_height = 0,       -- Minimum window height to show context
      })
    end,
  },
}
