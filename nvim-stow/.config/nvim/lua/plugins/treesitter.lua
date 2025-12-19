return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go",
					"gomod",
					"gosum",
					"javascript",
					"typescript",
					"lua",
					"php",
					"phpdoc",
					"html",
					"css",
					"scss",
					"json",
					"yaml",
					"markdown",
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
}
