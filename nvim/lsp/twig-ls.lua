local blink = require("blink.cmp")

return {
    cmd = { "twiggy-language-server", "--stdio" },
    filetypes = { "twig", "html.twig" },
    root_markers = { "composer.json", ".git", "templates/" },
    capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities()
    ),
}
