return {
	"saghen/blink.cmp",
	enabled = true,
	event = { "InsertEnter", "BufReadPost" },
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			config = function()
				-- Disable default Tab/S-Tab mappings to prevent cursor jumping
				require("luasnip").setup({
					-- Prevent LuaSnip from setting up default keymaps
					-- We use <C-j>/<C-k> via blink.cmp instead
				})
			end,
		},
	},
	build = "cargo build --release",
	opts = {
		snippets = {
			preset = "luasnip",
		},
        signature = { 
            enabled = true,
        },
		cmdline = {
			enabled = true,
			completion = {
				menu = { auto_show = true },
				list = { selection = { preselect = false, auto_insert = true } },
			},
		},
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				luasnip = {
					name = "LuaSnip",
					module = "luasnip.blink_source",
					score_offset = 95,
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 80,
				},
			},
		},

		keymap = {
			preset = "enter",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-y>"] = { "select_and_accept" },

			["<C-j>"] = { "snippet_forward", "fallback" },
			["<C-k>"] = { "snippet_backward", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },

			-- Explicitly make Tab just insert a tab (no snippet jumping)
			["<Tab>"] = { "fallback" },
			["<S-Tab>"] = { "fallback" },
		},
	},
	opts_extend = { "sources.default" },
}
