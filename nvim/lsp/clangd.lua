local blink = require("blink.cmp")

return {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = {
        "compile_commands.json",
        "compile_flags.txt",
        ".git",
    },
    capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities()
    ),
}



