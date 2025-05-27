return {
  {
    "tpope/vim-fugitive",
    config = function()
      -- Key mappings for Fugitive commands
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open Git Status" })
    end,
  },
}
