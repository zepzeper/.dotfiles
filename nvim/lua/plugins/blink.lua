return {
	{ "L3MON4D3/LuaSnip", keys = {} },
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "*",
		config = function()
			require("blink.cmp").setup({
				snippets = { preset = "luasnip" },
				signature = { enabled = true },
				appearance = {
					use_nvim_cmp_as_default = false, -- Disable nvim-cmp styling
					nerd_font_variant = "mono",
				},
				sources = {
					default = { "lazydev", "lsp", "path", "snippets", "buffer" },
					providers = {
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							score_offset = 100,
						},
						cmdline = {
							min_keyword_length = 2,
						},
					},
				},
				keymap = {
					["<C-f>"] = {},
				},
				cmdline = {
					enabled = false,
					completion = { menu = { auto_show = true } },
					keymap = {
						["<CR>"] = { "accept_and_enter", "fallback" },
					},
				},
				completion = {
					menu = {
						border = "single", -- Simple single-line border like Emacs
						scrollbar = false, -- Cleaner without scrollbar
						scrolloff = 1,
						draw = {
							columns = {
								{ "kind_icon", gap = 1 },
								{ "label", "label_description", gap = 1 },
								{ "kind", gap = 1 },
							},
							-- Emacs-like compact layout
							treesitter = { "lsp" },
						},
						-- More compact window like Emacs company-mode
						winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:PmenuSel,Search:None",
					},
					documentation = {
						window = {
							border = "single", -- Match menu border style
							scrollbar = false, -- Cleaner appearance
							-- Emacs-like minimal styling
							winhighlight = "Normal:Normal,FloatBorder:Normal,EndOfBuffer:Normal",
						},
						auto_show = true,
						auto_show_delay_ms = 100, -- Slight delay feels more natural
					},
					-- Show ghost text like Emacs inline completion
					ghost_text = {
						enabled = true,
					},
				},
			})
		end,
	},
}
