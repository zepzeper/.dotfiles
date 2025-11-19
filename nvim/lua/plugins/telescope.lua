return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.1.9",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").setup({
			pickers = {},
			extensions = {
				fzf = {},
			},
		})
		require("telescope").load_extension("fzf")

		vim.keymap.set("n", "<space>sg", require("telescope.builtin").live_grep)
		vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags)
		vim.keymap.set("n", "<space>ff", require("telescope.builtin").find_files)
		vim.keymap.set("n", "<space>fg", require("telescope.builtin").git_files)
		vim.keymap.set("n", "<space>fs", require("telescope.builtin").current_buffer_fuzzy_find)
		vim.keymap.set("n", "<space>fm", require("telescope.builtin").man_pages)

		vim.keymap.set("n", "<space>en", function()
			require("telescope.builtin").find_files({
				cwd = vim.fn.stdpath("config"),
			})
		end)
	end,
}
