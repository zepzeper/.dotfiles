return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
       indent = {
         char = "│",
         tab_char = "│",
       },
       scope = {
         enabled = false,
       },
    },
  }
}
