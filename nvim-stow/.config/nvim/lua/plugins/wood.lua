return {
  {
    "wood.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require('wood').setup()
    end,
  },
}
