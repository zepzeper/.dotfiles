return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  depencencies = {
    "nvim-lua/plenary.nvim",
  },

  keys = {
    { "<leader>gs", "<cmd>LazyGit<cr>", desc = "Open lazygit" },
  },
}
