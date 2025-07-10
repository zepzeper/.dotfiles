local blink = require("blink.cmp")
return {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "php" },
    root_markers = { "index.html", ".git" },
    root_dir = function(fname)
        local filename = fname
        if type(fname) == "number" then
            filename = vim.api.nvim_buf_get_name(fname)
        end
        
        -- Only activate for PHP files in views folders
        if filename:match("/views/") or 
           filename:match("/templates/") or 
           filename:match("/resources/views/") then
            return vim.fn.getcwd()
        end
        
        return nil
    end,
    init_options = { provideFormatter = true },
    capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities()
    ),
}
