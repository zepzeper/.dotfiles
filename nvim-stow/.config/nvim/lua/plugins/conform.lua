return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				php = { "php_cs_fixer" },
			},
		})
		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ bufnr = 0 })
		end)
	end,
}
