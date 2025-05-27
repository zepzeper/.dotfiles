return {
    "drewxs/ash.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("ash").setup({
          transparent = true,
          term_colors = true,
        })
        vim.cmd([[colorscheme ash]])
    end
}
