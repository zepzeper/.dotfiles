local mason_dap = require("mason-nvim-dap")
local dap = require("dap")
local dap_view = require("dap-view")
local dap_virtual_text = require("nvim-dap-virtual-text")

-- Dap Virtual Text
dap_virtual_text.setup()

dap_view.setup({
    winbar = {
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
        controls = { enabled = true, position = "left" },
    },
})

mason_dap.setup({
    ensure_installed = { "php-debug-adapter" },
    automatic_installation = true,
    handlers = {
        function(config)
            require("mason-nvim-dap").default_setup(config)
        end,
    },
})

-- This can either be done by setting xdebug.client_host to your IP or by setting xdebug.discover_client_host = 1
dap.adapters.php = {
    type = 'executable',
    command = 'node',
    args = { '/home/wouter/personal/vscode-php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
    {
        name = "Listen (Local)",
        type = "php",
        request = "launch",
        port = 9003,
    },
    {
        name = "Listen (Remote)",
        type = "php",
        request = "launch",
        port = 9000,
    }
}

vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

dap.listeners.before.attach.dapui_config = function()
    dap_view.open()
end
dap.listeners.before.launch.dapui_config = function()
    dap_view.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dap_view.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dap_view.close()
end
