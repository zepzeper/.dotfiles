-- Centralized keymap configuration for Neovim
-- Keeps all key bindings in one place to prevent conflicts

local keymap = vim.keymap.set
local default_opts = { noremap = true, silent = true }

local M = {}

function M.editing()
    -- Disable unwanted default bindings
    keymap("n", "<C-c>", "<Nop>", default_opts)
    keymap("n", "<C-z>", "<Nop>", default_opts)

    -- Keep cursor centered when jumping
    keymap("n", "<C-u>", "<C-u>zz", default_opts)
    keymap("n", "<C-d>", "<C-d>zz", default_opts)
    keymap("n", "n", "nzzzv", { desc = "Next search (centered)" })
    keymap("n", "N", "Nzzzv", { desc = "Prev search (centered)" })

    -- Move visual selection up/down
    keymap("v", "J", ":m '>+1<CR>gv=gv", default_opts)
    keymap("v", "K", ":m '<-2<CR>gv=gv", default_opts)

    -- Paste without yanking in visual mode
    keymap("x", "<leader>p", '"_dP', { desc = "Paste without yank" })

    -- Toggle search highlighting
    keymap("n", "<leader>;h", ":set hlsearch!<CR>", { desc = "Toggle search highlight" })

    -- Diffview toggle
    keymap("n", "<leader>v", function()
        require("zepzeper.keymaps.utils").toggle_diffview()
    end, { desc = "Toggle diffview" })
end

function M.lsp()
    local tb = require("telescope.builtin")

    -- Navigation (Telescope-powered)
    keymap("n", "gd", tb.lsp_definitions, { desc = "Go to definition" })
    keymap("n", "gr", tb.lsp_references, { desc = "Go to references" })
    keymap("n", "gi", tb.lsp_implementations, { desc = "Go to implementation" })
    keymap("n", "gt", tb.lsp_type_definitions, { desc = "Go to type definition" })

    -- Keep native (better direct jump)
    keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

    -- Documentation and info
    keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
    keymap({ "n", "i" }, "<C-\\>", vim.lsp.buf.signature_help, default_opts)

    -- Code actions and refactoring
    keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
    keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

    -- Symbols (Telescope)
    keymap("n", "<leader>ds", tb.lsp_document_symbols, { desc = "Document symbols" })
    keymap("n", "<leader>ws", function()
        tb.lsp_workspace_symbols({ query = vim.fn.input("Query: ") })
    end, { desc = "Workspace symbols" })

    -- Diagnostics navigation (keep fast native + your custom)
    keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
    keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

    keymap("n", "[e", function()
        require("zepzeper.native.lsp").prev_diag()
    end, { desc = "Previous diagnostic (custom)" })
    keymap("n", "]e", function()
        require("zepzeper.native.lsp").next_diag()
    end, { desc = "Next diagnostic (custom)" })

    keymap("n", "[E", function()
        require("zepzeper.native.lsp").prev_error()
    end, { desc = "Previous error" })
    keymap("n", "]E", function()
        require("zepzeper.native.lsp").next_error()
    end, { desc = "Next error" })

    -- Diagnostic display
    keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
    keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
    keymap("n", "<leader>dd", tb.diagnostics, { desc = "Diagnostics (Telescope)" })

    -- Toggle inlay hints
    keymap("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle inlay hints" })
end

function M.harpoon()
    local harpoon = require("harpoon")
    local list = harpoon:list()

    keymap("n", "<leader>a", function()
        list:add()
    end, { desc = "Harpoon: add file" })

    keymap("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(list)
    end, { desc = "Harpoon: quick menu" })

    -- Quick navigation to marked files
    keymap("n", "<C-h>", function() list:select(1) end, { desc = "Harpoon: file 1" })
    keymap("n", "<C-j>", function() list:select(2) end, { desc = "Harpoon: file 2" })
    keymap("n", "<C-k>", function() list:select(3) end, { desc = "Harpoon: file 3" })
    keymap("n", "<C-l>", function() list:select(4) end, { desc = "Harpoon: file 4" })
end


function M.completion()
    local cmp = require("cmp")

    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({
                select = false,
                behavior = cmp.ConfirmBehavior.Insert,
            }),
        }),
    })

    -- Command-line completion
    keymap("c", "<C-Space>", function()
        require("cmp").complete()
    end, default_opts)
end

function M.quickfix()
    keymap("n", "<C-c>c", ":cclose<CR>", { desc = "Close quickfix" })
    keymap("n", "<C-c>o", ":copen<CR>", { desc = "Open quickfix" })
    keymap("n", "<C-c>n", ":cnext<CR>", { desc = "Next quickfix" })
    keymap("n", "<C-c>p", ":cprev<CR>", { desc = "Previous quickfix" })
end

function M.dev_utils()
    -- Source and execute Lua code
    keymap("n", "<space><space>x", "<cmd>source %<CR>", { desc = "Source current file" })
    keymap("n", "<space>x", ":.lua<CR>", { desc = "Execute line as Lua" })

    -- Reload custom plugins
    keymap("n", "<leader>rr", function()
        local plugins = { "zemac", "bicycle" }
        for _, plugin_name in ipairs(plugins) do
            -- Clear loaded modules
            for module_name, _ in pairs(package.loaded) do
                if module_name:match("^" .. plugin_name) then
                    package.loaded[module_name] = nil
                end
            end
            require(plugin_name).setup()
        end
        vim.notify("Plugins reloaded: " .. table.concat(plugins, ", "), vim.log.levels.INFO)
    end, { desc = "Reload custom plugins" })

    -- C/C++ header/source switching
    keymap("n", "<leader>oh", function()
        vim.cmd.edit(vim.fn.expand("%:r") .. ".h")
    end, { desc = "Open header file" })
    keymap("n", "<leader>oc", function()
        vim.cmd.edit(vim.fn.expand("%:r") .. ".c")
    end, { desc = "Open source file" })
end

function M.explorer()
    keymap("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })
end

function M.command_aliases()
    vim.cmd("command! Wq wq")
    vim.cmd("command! W w")
    vim.cmd("command! Q q")
    vim.cmd("command! X x")
    vim.cmd("command! Xa xa")
end

function M.init()
    M.editing()
    M.lsp()
    M.harpoon()
    M.completion()
    M.quickfix()
    M.dev_utils()
    M.explorer()
    M.command_aliases()
end

return M
