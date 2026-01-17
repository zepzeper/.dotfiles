return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			-- Use the same bottom pane style you have with Telescope
			winopts = {
				height = 0.40,
				width = 1.0,
				row = 1.0,
				col = 0.0,
				border = "none",
				preview = {
					layout = "horizontal",
					horizontal = "right:50%",
				},
			},
			fzf_opts = {
				["--layout"] = "reverse",
				["--info"] = "inline",
			},
            file_ignore_patterns = { "Feature files/", "node_modules/", ".git/" },

		})

		local fzf = require("fzf-lua")
		local kg_path = vim.fn.expand("~/knowledge-garden")

		vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "Find files" })
		vim.keymap.set("n", "<C-p>", fzf.git_files, { desc = "Git files" })
		vim.keymap.set("n", "<leader>lg", fzf.live_grep, { desc = "Live grep" })
		vim.keymap.set("n", "<C-_>", fzf.blines, { desc = "Current buffer fuzzy find" })
		vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
		vim.keymap.set("n", "<leader>fm", fzf.man_pages, { desc = "Man pages" })

		-- Edit Neovim config
		vim.keymap.set("n", "<leader>en", function()
			fzf.files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Edit Neovim config" })

		-- Knowledge Garden keymaps
		-- Quick note finder (fuzzy find by filename)
		vim.keymap.set("n", "<leader>kf", function()
			fzf.files({
				cwd = kg_path,
				prompt = "Notes> ",
				file_ignore_patterns = { "^%.", "/%." }, -- Hide dotfiles and dot directories
			})
		end, { desc = "Find note" })

		-- Search note content (live grep)
		vim.keymap.set("n", "<leader>ks", function()
			fzf.live_grep({
				cwd = kg_path,
				prompt = "Search> ",
				file_ignore_patterns = { "^%.", "/%." },
			})
		end, { desc = "Search notes" })
	end,
}
