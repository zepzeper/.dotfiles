local blink = require("blink.cmp")

return {
    cmd = { "sourcekit-lsp" },
    filetypes = { "swift" },
    root_markers = {
        "Package.swift",
        ".git",
        "*.xcodeproj",
        "*.xcworkspace",
    },
    capabilities = vim.tbl_deep_extend(
        "force",
        {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        },
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities()
    ),
}
