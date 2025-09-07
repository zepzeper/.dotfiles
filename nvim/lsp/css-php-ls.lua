local blink = require("blink.cmp")
return {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "php" },
    root_markers = { "package.json", ".git" },
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
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
    capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities()
    ),
}
