require("nvim-treesitter").setup({
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    indent = { enable = true },
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local ok, _ = pcall(vim.treesitter.start)
    if not ok then
      -- silently ignore filetypes with no parser
    end
  end,
})
