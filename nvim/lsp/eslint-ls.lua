return {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = {
		"eslint.config.js",
		"eslint.config.mjs",
		".eslintrc",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.json",
		"package.json",
	},
	settings = {
		validate = "on",
		packageManager = "npm",
		useESLintClass = false,
		experimental = {
			useFlatConfig = true, -- Enable flat config support
		},
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = true,
		quiet = false,
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		run = "onType",
		problems = {
			shortenToSingleLine = false,
		},
		nodePath = "",
		workingDirectory = {
			mode = "auto",
		},
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
	},
	on_new_config = function(config, new_root_dir)
		config.settings.workspaceFolder = {
			uri = vim.uri_from_fname(new_root_dir),
			name = vim.fn.fnamemodify(new_root_dir, ":t"),
		}
	end,
}
