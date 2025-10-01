return {
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    opts = {
      date_format = "%d.%m.%Y",
      virtual_style = "right_align",
      focus_blame = true,
      max_summary_width = 30,
      blame_options = { "-v" },
      commit_detail_view = "vsplit",
      view = "window", -- default view
    },
    config = function(_, opts)
      local blame = require("blame")
      blame.setup(opts)

      -- Define the keymap after the plugin is initialized
      vim.keymap.set("n", "<space>b", "<cmd>BlameToggle<CR>", { desc = "Toggle blame" })
    end,
  },
}
