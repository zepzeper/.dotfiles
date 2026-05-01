local util = require("lspconfig.util")

-- These LSPs use the configs provided by `nvim-lspconfig`.
--vim.lsp.enable("bashls")
--vim.lsp.enable("rust_analyzer")
--vim.lsp.enable("yamlls")
--vim.lsp.enable("gopls")
--vim.lsp.enable("buf_ls")
--vim.lsp.enable("clangd")
--vim.lsp.enable("ts_ls")
--vim.lsp.enable("cmake")
--vim.lsp.enable("html")
--vim.lsp.enable("jsonls")
--vim.lsp.enable("lua_ls")
-- vim.lsp.enable("phpactor")     
vim.lsp.enable("intelephense")     
--vim.lsp.enable("zls")          
--vim.lsp.enable("glslls")       
--vim.lsp.enable("rnix-lsp")

-- Override some of the configs.
--vim.lsp.config("cmake", {
--    root_dir = LU.root_pattern("CMakeLists.txt"),
--})

vim.lsp.config("intelephense", {
    cmd = { "intelephense", "--stdio" },
    filetypes = { "php" },
    root_markers = { "composer.json", ".git" },
    init_options = {
        licenceKey = "00YNPEL2NKC5IE5",
    },
})

-- vim.lsp.config("phpactor", {
--     cmd = { "phpactor", "language-server" },
--     filetypes = { "php" },
--     init_options = {
--         ["language_server_phpstan.enabled"] = true,
--     },
-- })
