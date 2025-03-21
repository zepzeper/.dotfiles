return {
  {
    "theprimeagen/harpoon",
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      -- Key mappings
      vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon: Add File" })
      vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon: Toggle Quick Menu" })

      vim.keymap.set("n", "<leader>h", function() ui.nav_file(1) end, { desc = "Harpoon: Navigate to File 1" })
      vim.keymap.set("n", "<leader>j", function() ui.nav_file(2) end, { desc = "Harpoon: Navigate to File 2" })
      vim.keymap.set("n", "<leader>k", function() ui.nav_file(3) end, { desc = "Harpoon: Navigate to File 3" })
      vim.keymap.set("n", "<leader>l", function() ui.nav_file(4) end, { desc = "Harpoon: Navigate to File 4" })
    end,
  },
}
