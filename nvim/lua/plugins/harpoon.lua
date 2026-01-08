return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		-- REQUIRED
		harpoon:setup({
			settings = {
				save_on_toggle = true,
			},
			menu = {
				width = 60,
				height = 10,
				borderchars = { "─", " ", " ", " ", "─", "─", " ", " " },
			},
		})
		-- REQUIRED

		-- Add to harpoon
		vim.keymap.set("n", "<C-h>a", function()
			harpoon:list():add()
		end, { desc = "Add to harpoon" })

		-- Menu stays as <C-e>
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon menu" })

		-- Quick select with Ctrl+h then number
		vim.keymap.set("n", "<C-h>1", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon 1" })
		vim.keymap.set("n", "<C-h>2", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon 2" })
		vim.keymap.set("n", "<C-h>3", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon 3" })
		vim.keymap.set("n", "<C-h>4", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon 4" })
		vim.keymap.set("n", "<C-h>5", function()
			harpoon:list():select(5)
		end, { desc = "Harpoon 5" })
	end,
}
