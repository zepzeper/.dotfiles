return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim", -- optional - enhanced diff view
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function()
		require("neogit").setup({
			kind = "tab", -- "split", "tab", "vsplit", "floating", "auto"
			disable_commit_confirmation = false,
			disable_builtin_notifications = false,
			use_magit_keybindings = false,
			commit_editor = {
				kind = "auto",
			},
			popup = {
				kind = "auto",
			},
			signs = {
				section = { ">", "v" },
				item = { ">", "v" },
				hunk = { "", "" },
			},
			integrations = {
				telescope = true,
				diffview = true,
			},
		})

		vim.keymap.set("n", "<leader>gs", "<cmd>Neogit<cr>", { desc = "Git status" })
	end,
}
