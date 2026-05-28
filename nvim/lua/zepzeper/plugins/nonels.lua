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

    on_attach = function(client, bufnr)
        if client:supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
                group = augroup,
                buffer = bufnr,
            })

            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        timeout_ms = 2000,
                        filter = function(c)
                            return c.name == "null-ls"
                        end,
                    })
                end,
            })
        end
    end,
})
