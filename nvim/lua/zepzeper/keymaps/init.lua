-- Centralized keymap configuration for Neovim
-- Keeps all key bindings in one place to prevent conflicts
local n, i, v = "n", "i", "v"
local n_i = { n, i }

local keymap = vim.keymap.set
local default_opts = { noremap = true, silent = true }

local M = {}

function M.init()
    M.core() -- Keymaps migrated from old config
    M.telescope()
    M.lsp()
    M.harpoon()
    M.quickfix()
    M.dap()
    M.dev_utils()
    M.command_aliases()
end

function M.core()
    keymap(n, "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })
    keymap(n, "<leader>b", "<cmd>Blame<CR>", { desc = "Blame" })
    -- Disable Ctrl-c and Ctrl-z in normal mode
    keymap(n, "<C-c>", "<Nop>", default_opts)
    keymap(n, "<C-z>", "<Nop>", default_opts)

    -- Source and execute Lua
    keymap(n, "<space><space>x", "<cmd>source %<CR>", { desc = "Source current file" })
    keymap(n, "<space>x", ":.lua<CR>", { desc = "Execute line as Lua" })

    -- Keep cursor centered when jumping
    keymap(n, "<C-u>", "<C-u>zz", default_opts)
    keymap(n, "<C-d>", "<C-d>zz", default_opts)
    keymap(n, n, "nzzzv", { desc = "Next search (centered)" })
    keymap(n, "N", "Nzzzv", { desc = "Prev search (centered)" })

    -- Move visual selection up/down
    keymap(v, "J", ":m '>+1<CR>gv=gv", default_opts)
    keymap(v, "K", ":m '<-2<CR>gv=gv", default_opts)

    -- Paste without yanking in visual mode
    keymap(n, "<leader>p", '"_dP', { desc = "Paste without yank" })

    -- Toggle search highlighting
    keymap(n, "<leader>;h", ":set hlsearch!<CR>", { desc = "Toggle search highlight" })

    -- Diffview toggle
    keymap(n, "<leader>v", function()
        require("zepzeper.keymaps.utils").toggle_diffview()
    end, { desc = "Toggle diffview" })
end

function M.telescope()
    -- Matching old config style with <leader> prefixes
    keymap(n, "<leader>sf", function()
        require("telescope.builtin").find_files()
    end, { desc = "Find files" })
    keymap(n, "<C-p>", function()
        require("telescope.builtin").git_files()
    end, { desc = "Git files" })
    keymap(n, "<leader>lg", function()
        require("telescope.builtin").live_grep()
    end, { desc = "Live grep" })
    keymap(n, "<leader>lw", function()
        require("telescope.builtin").grep_string()
    end, { desc = "Live grep" })
    keymap(n, "<leader>fh", function()
        require("telescope.builtin").help_tags({})
    end, { desc = "Help tags" })
    keymap(n, "<leader>fm", function()
        require("telescope.builtin").man_pages({ sections = { "ALL" } })
    end, { desc = "Man pages" })

    -- Edit Neovim config
    keymap(n, "<leader>ec", function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Edit Neovim config" })

    keymap(n, "<C-n>", "<Cmd>Telescope buffers previewer=false<CR>", default_opts)
    keymap(n, "<leader>E", "<Cmd>Telescope diagnostics line_width=full bufnr=0<CR>", { desc = "Buffer diagnostics" })

    -- TODO: I don't want this to jump if there is only one entry.
    keymap(n, "gr", "<Cmd>Telescope lsp_references<CR>", default_opts)
    keymap(n, "gd", "<Cmd>Telescope lsp_definitions<CR>", default_opts)
    keymap(n, "gi", "<Cmd>Telescope lsp_implementations<CR>", default_opts)
    keymap(n, "gt", "<Cmd>Telescope lsp_type_definitions<CR>", default_opts)
end

function M.lsp()
    keymap(n, "<leader>rn", function()
        pcall(vim.lsp.buf.rename)
    end, default_opts)

    -- Diagnostics navigation (keep fast native + your custom)
    keymap(n, "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
    keymap(n, "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    keymap(n, "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, default_opts)

    keymap(n, "[e", function()
        require("zepzeper.native.lsp").prev_diag()
    end, { desc = "Previous diagnostic (custom)" })
    keymap(n, "]e", function()
        require("zepzeper.native.lsp").next_diag()
    end, { desc = "Next diagnostic (custom)" })

    keymap(n, "[E", function()
        require("zepzeper.native.lsp").prev_error()
    end, { desc = "Previous error" })
    keymap(n, "]E", function()
        require("zepzeper.native.lsp").next_error()
    end, { desc = "Next error" })

    -- Diagnostic display
    keymap(n, "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
    keymap(n, "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
    -- keymap(n, "<leader>dd", tb.diagnostics, { desc = "Diagnostics (Telescope)" })

    -- Toggle inlay hints
    keymap(n, "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle inlay hints" })
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

function M.harpoon()
    local harpoon = require("harpoon")
    local list = harpoon:list()

    -- Add file
    keymap(n, "<leader>a", function()
        list:add()
    end, { desc = "Harpoon add file" })

    -- Git blame
    keymap(n, "<leader>gb", function()
        require("blame").toggle()
    end, { desc = "Git blame" })

    -- Quick menu
    keymap(n, "<C-e>", function()
        harpoon.ui:toggle_quick_menu(list)
    end, { desc = "Harpoon quick menu" })

    -- Navigate to files
    keymap(n, "<C-h>", function() list:select(1) end, { desc = "Harpoon file 1" })
    keymap(n, "<C-j>", function() list:select(2) end, { desc = "Harpoon file 2" })
    keymap(n, "<C-k>", function() list:select(3) end, { desc = "Harpoon file 3" })
    keymap(n, "<C-l>", function() list:select(4) end, { desc = "Harpoon file 4" })
end


function M.quickfix()
    keymap(n, "<C-c>c", ":cclose<CR>", { desc = "Close quickfix" })
    keymap(n, "<C-c>o", ":copen<CR>", { desc = "Open quickfix" })
    keymap(n, "<C-c>n", ":cnext<CR>", { desc = "Next quickfix" })
    keymap(n, "<C-c>p", ":cprev<CR>", { desc = "Previous quickfix" })
end

function M.dap()
    keymap(n, '<F5>', function() require('dap').continue() end)
    keymap(n, '<F6>', function() require('dap').step_over() end)
    keymap(n, '<F7>', function() require('dap').step_into() end)
    keymap(n, '<F8>', function() require('dap').step_out() end)
    keymap(n, '<Leader>dt', function() require('dap').toggle_breakpoint() end)
    keymap(n, '<Leader>dr', function() require('dap').repl.open() end)
    keymap(n, '<Leader>dl', function() require('dap').run_last() end)
    keymap(n, '<Leader>dc', function() require('dap').run_to_cursor() end)
    -- vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
    --     require('dap.ui.widgets').hover()
    -- end)
    -- vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
    --     require('dap.ui.widgets').preview()
    -- end)
    keymap(n, '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
    end)
    keymap(n, '<Leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
    end)
end

function M.dev_utils()
    -- Source and execute Lua code
    keymap(n, "<space><space>x", "<cmd>source %<CR>", { desc = "Source current file" })
    keymap(n, "<space>x", ":.lua<CR>", { desc = "Execute line as Lua" })

    -- Reload custom plugins
    keymap(n, "<leader>rr", function()
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
    keymap(n, "<leader>oh", function()
        vim.cmd.edit(vim.fn.expand("%:r") .. ".h")
    end, { desc = "Open header file" })
    keymap(n, "<leader>oc", function()
        vim.cmd.edit(vim.fn.expand("%:r") .. ".c")
    end, { desc = "Open source file" })
end

function M.command_aliases()
    vim.cmd("command! Wq wq")
    vim.cmd("command! W w")
    vim.cmd("command! Q q")
    vim.cmd("command! X x")
    vim.cmd("command! Xa xa")
end

return M
