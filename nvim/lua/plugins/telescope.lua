return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.1.9",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "dist/.*" },
				layout_strategy = "bottom_pane",
				layout_config = {
					height = 32,
				},
				border = true,
				borderchars = {
					prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
					results = { " " },
					preview = { " " },
				},
				prompt_prefix = "🔍 ",
				selection_caret = "➤ ",
				entry_prefix = "  ",
				sorting_strategy = "ascending",
				results_title = false,
				prompt_title = false,
				previewer = false,
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})
		require("telescope").load_extension("fzf")

		vim.keymap.set("n", "<space>sg", require("telescope.builtin").live_grep, { desc = "Live grep" })
		vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags, { desc = "Help tags" })
		vim.keymap.set("n", "<space>ff", require("telescope.builtin").find_files, { desc = "Find files" })
		vim.keymap.set("n", "<space>fg", require("telescope.builtin").git_files, { desc = "Git files" })
		vim.keymap.set(
			"n",
			"<space>fs",
			require("telescope.builtin").current_buffer_fuzzy_find,
			{ desc = "Current buffer fuzzy find" }
		)
		vim.keymap.set("n", "<space>fm", require("telescope.builtin").man_pages, { desc = "Man pages" })
		vim.keymap.set("n", "<space>en", function()
			require("telescope.builtin").find_files({
				cwd = vim.fn.stdpath("config"),
			})
		end, { desc = "Edit Neovim config" })
	end,
}
