local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    temp_dir = "/tmp",
    sources = {
        null_ls.builtins.diagnostics.phpstan.with({
            command = "vendor/bin/phpstan",
        }),

        null_ls.builtins.diagnostics.phpcs.with({
            command = "vendor/bin/phpcs",
        }),
    },
})

vim.api.nvim_create_user_command("PhpstanToggle", function()
    null_ls.toggle({ name = "phpstan" })
end, {})
