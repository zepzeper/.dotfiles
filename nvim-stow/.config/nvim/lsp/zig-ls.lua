local blink = require("blink.cmp")

return {
    cmd = { "zls" },
    filetypes = { "zig" },
    root_markers = { "build.zig.zon", ".git" },
    capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities()
    ),
}
