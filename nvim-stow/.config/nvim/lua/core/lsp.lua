local notify = require("util.lsp_notify")

-- Enable LSP servers
vim.lsp.enable({
    "lua-ls",
    "gopls",
    "ts-ls",
    "eslint-ls",
    "rust-analyzer",
    "php-ls",
    "clangd",
    "html-ls",
    "twig-ls",
    "python-ls",
})

-- Diagnostics configuration
vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "single",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})

----------------------------------------------------------------------
-- LSP RESTART
----------------------------------------------------------------------

local function restart_lsp(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        notify.warn("LSP Restart", "No LSP clients to restart")
        return
    end

    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
    end

    notify.info("LSP Restart", "Restarting LSP…")

    vim.defer_fn(function()
        vim.cmd("edit")
        notify.info("LSP Restart", "LSP restarted")
    end, 120)
end

vim.api.nvim_create_user_command("LspRestart", restart_lsp, {})

----------------------------------------------------------------------
-- LSP STATUS
----------------------------------------------------------------------

local function lsp_status()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        notify.error("LSP Status", "No LSP clients attached")
        return
    end

    local lines = {}
    table.insert(lines, "LSP Status for buffer " .. bufnr)
    table.insert(lines, "─────────────────────────────────")

    for i, client in ipairs(clients) do
        table.insert(lines, string.format("Client %d: %s (ID: %d)", i, client.name, client.id))
        table.insert(lines, "  Root: " .. (client.config.root_dir or "N/A"))
        table.insert(lines, "  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

        local caps = client.server_capabilities
        local features = {}
        if caps.completionProvider then table.insert(features, "completion") end
        if caps.hoverProvider then table.insert(features, "hover") end
        if caps.definitionProvider then table.insert(features, "definition") end
        if caps.referencesProvider then table.insert(features, "references") end
        if caps.renameProvider then table.insert(features, "rename") end
        if caps.codeActionProvider then table.insert(features, "code_action") end
        if caps.documentFormattingProvider then table.insert(features, "formatting") end

        table.insert(lines, "  Features: " .. table.concat(features, ", "))
        table.insert(lines, "")
    end

    notify.info("LSP Status", table.concat(lines, "\n"))
end

vim.api.nvim_create_user_command("LspStatus", lsp_status, { desc = "Show detailed LSP status" })

----------------------------------------------------------------------
-- LSP CAPABILITIES
----------------------------------------------------------------------

local function check_lsp_capabilities()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        notify.warn("LSP Capabilities", "No LSP clients attached")
        return
    end

    local blocks = {}

    for _, client in ipairs(clients) do
        local caps = client.server_capabilities
        local lines = {}
        table.insert(lines, "Capabilities for " .. client.name .. ":")

        local capability_list = {
            { "Completion", caps.completionProvider },
            { "Hover", caps.hoverProvider },
            { "Signature Help", caps.signatureHelpProvider },
            { "Go to Definition", caps.definitionProvider },
            { "Go to Declaration", caps.declarationProvider },
            { "Go to Implementation", caps.implementationProvider },
            { "Go to Type Definition", caps.typeDefinitionProvider },
            { "Find References", caps.referencesProvider },
            { "Document Highlight", caps.documentHighlightProvider },
            { "Document Symbol", caps.documentSymbolProvider },
            { "Workspace Symbol", caps.workspaceSymbolProvider },
            { "Code Action", caps.codeActionProvider },
            { "Code Lens", caps.codeLensProvider },
            { "Document Formatting", caps.documentFormattingProvider },
            { "Document Range Formatting", caps.documentRangeFormattingProvider },
            { "Rename", caps.renameProvider },
            { "Folding Range", caps.foldingRangeProvider },
            { "Selection Range", caps.selectionRangeProvider },
        }

        for _, cap in ipairs(capability_list) do
            local status = cap[2] and "✓" or "✗"
            table.insert(lines, string.format("  %s %s", status, cap[1]))
        end

        table.insert(blocks, table.concat(lines, "\n"))
    end

    notify.info("LSP Capabilities", table.concat(blocks, "\n\n"))
end

vim.api.nvim_create_user_command("LspCapabilities", check_lsp_capabilities, { desc = "Show LSP capabilities" })

----------------------------------------------------------------------
-- LSP DIAGNOSTICS
----------------------------------------------------------------------

local function lsp_diagnostics_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(bufnr)
    local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

    for _, diagnostic in ipairs(diagnostics) do
        local s = vim.diagnostic.severity[diagnostic.severity]
        counts[s] = counts[s] + 1
    end

    local msg = string.format(
        "Diagnostics for buffer %d:\nErrors: %d\nWarnings: %d\nInfo: %d\nHints: %d\nTotal: %d",
        bufnr,
        counts.ERROR,
        counts.WARN,
        counts.INFO,
        counts.HINT,
        #diagnostics
    )

    notify.info("LSP Diagnostics", msg)
end

vim.api.nvim_create_user_command("LspDiagnostics", lsp_diagnostics_info, { desc = "Show LSP diagnostics count" })
