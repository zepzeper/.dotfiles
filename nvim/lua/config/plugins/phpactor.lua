return {
  "gbprod/phpactor.nvim",
  ft = "php",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
    "folke/noice.nvim"
  },
  opts = {
    install = {
      path = "/opt/",
      branch = "master",
      bin = "/opt/homebrew/bin/phpactor", -- Adjust this path to your Phpactor installation
      php_bin = "php",
      composer_bin = "composer",
      git_bin = "git",
      check_on_startup = "none",
    },
    lspconfig = {
      enabled = true,
      options = {},
    },
  },
  config = function(_, opts)
    require("phpactor").setup(opts)
  end
}
