return {
	"luckasRanarison/nvim-devdocs",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		dir_path = vim.fn.stdpath("data") .. "/devdocs",
		telescope = {},
		float_win = {
			relative = "editor",
			height = 50,
			width = 100,
			border = "single",
		},
		wrap = false,
		previewer_cmd = nil,
		cmd_args = {},
		cmd_ignore = {},
		picker_cmd = false,
		picker_cmd_args = {},
		mappings = {
			open_in_browser = "",
		},
		ensure_installed = {
			"go",
			"typescript",
			"php",
			"lua",
		},
		after_open = function(bufnr) end,
	},
	keys = {
		{
			"<leader>d",
			function()
				local ft = vim.bo.filetype
				vim.cmd("DevdocsOpenFloat " .. ft)
			end,
			desc = "DevDocs (current filetype)",
		},
		{
			"<leader>D",
			"<cmd>DevdocsOpenFloat<cr>",
			desc = "DevDocs (all docs)",
		},
	},
}
