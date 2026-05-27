local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.phpstan.with({
            command = "vendor/bin/phpstan",
        }),

        null_ls.builtins.diagnostics.phpcs.with({
            command = "vendor/bin/phpcs",
        }),
    },

    on_attach = function(client, bufnr)
        if client:supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
                buffer = bufnr,
                event = "BufWritePre",
            })

            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        timeout_ms = 2000,
                    })
                end,
            })
        end
    end,
})
