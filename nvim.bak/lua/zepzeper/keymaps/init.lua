-- Centralized keymap configuration for Neovim
-- Keeps all key bindings in one place to prevent conflicts
local n, i, v = "n", "i", "v"
local n_i = { n, i }

local keymap = vim.keymap.set
local default_opts = { noremap = true, silent = true }

local M = {}

function M.init()
    M.core()
    M.fff()
    M.lsp()
    M.trouble()
    M.neogit()
    M.undotree()
    M.vi_sql()
    M.harpoon()
    M.quickfix()
    M.tabs()
    M.dap()
    M.neotest()
    M.cmdline()
    M.dev_utils()
    M.command_aliases()
end

function M.core()
    keymap(n, "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })
    keymap(n, "<leader>b", "<cmd>Blame<CR>", { desc = "Blame" })
    -- Disable Ctrl-c and Ctrl-z in normal mode
    keymap(n, "<C-c>", "<Nop>", default_opts)
    keymap(n, "<C-z>", "<Nop>", default_opts)

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
    keymap(n, "<leader>tt", "<Cmd>TSContext toggle<CR>", default_opts)
end

function M.fff()
    keymap(n, "<leader>ff", function()
        require("fff").find_files()
    end, { desc = "Find files" })
    keymap(n, "<C-p>", function()
        require("fff").find_files()
    end, { desc = "Find files (git-aware)" })
    keymap(n, "<leader>lg", function()
        require("fff").live_grep()
    end, { desc = "Live grep" })
    keymap(n, "<leader>fw", function()
        require("fff").live_grep({ query = vim.fn.expand("<cword>") })
    end, { desc = "Find word" })
    keymap(n, "<leader>fh", function()
        vim.cmd("help " .. vim.fn.input("Help: "))
    end, { desc = "Help tags" })
    keymap(n, "<leader>fm", function()
        vim.cmd("Man " .. vim.fn.input("Man page: "))
    end, { desc = "Man pages" })

    -- Edit Neovim config
    keymap(n, "<leader>ec", function()
        require("fff").find_files_in_dir(vim.fn.stdpath("config"))
    end, { desc = "Edit Neovim config" })

    keymap(n, "<C-n>", function()
        require("fff").find_files()
    end, { desc = "Find files" })
    keymap(n, "<leader>E", function()
        vim.diagnostic.open_float()
    end, { desc = "Buffer diagnostics" })

    keymap(i, '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
end

function M.lsp()
    keymap(n, "<leader>rn", function()
        pcall(vim.lsp.buf.rename)
    end, vim.tbl_deep_extend("force", default_opts, {
        desc = "LSP rename",
    }))

    -- Diagnostics navigation (keep fast native + your custom)
    keymap(n, "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
    keymap(n, "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    keymap(n, "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, vim.tbl_deep_extend("force", default_opts, {
        desc = "Code actions",
    }))


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

    -- Toggle inlay hints
    keymap(n, "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle inlay hints" })
end

function M.cmdline()
    keymap("c", "<C-Space>", function()
        require("cmp").complete()
    end, default_opts)
end

function M.trouble()
    keymap(n, "gr", "<cmd>Trouble lsp_references<cr>", { desc = "LSP references" })
    keymap(n, "gd", "<cmd>Trouble lsp_definitions<cr>", { desc = "LSP definitions" })
    keymap(n, "gi", "<cmd>Trouble lsp_implementations<cr>", { desc = "LSP implementations" })
    keymap(n, "gt", "<cmd>Trouble lsp_type_definitions<cr>", { desc = "LSP type definitions" })
end

function M.neogit()
    keymap(n, "<leader>gs", "<cmd>Neogit<cr>", { desc = "Neogit status" })
end

function M.undotree()
    keymap(n, "<BS>u", function()
        require("undotree").toggle()
    end, { desc = "Toggle undotree" })
end

function M.vi_sql()
    keymap("n", "<leader>ql", function()
        vim.cmd.tabnew()
        vim.bo.filetype = "sql"
    end, {
    desc = "Open SQL tab",
})

    keymap(n, "<leader>vs", "<cmd>ViSQL<cr>", { desc = "Open vi-sql" })
end

function M.harpoon()
    local harpoon = require("harpoon")
    local list = harpoon:list()

    -- Add file
    keymap(n, "<leader>a", function()
        list:add()
    end, { desc = "Harpoon add file" })

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

function M.tabs()
    keymap(n, "<C-t>c", ":tabclose<CR>", { desc = "Close tab" })
    keymap(n, "<C-t>o", ":tabnew<CR>", { desc = "Open tab" })
    keymap(n, "<C-t>h", ":tabnew %<CR>", { desc = "Open current file in new tab" })
    keymap(n, "<C-t>n", ":tabnext<CR>", { desc = "Next tab" })
    keymap(n, "<C-t>p", ":tabprevious<CR>", { desc = "Previous tab" })
end

function M.dap()
    keymap(n, '<F5>', function() require('dap').continue() end, { desc = "DAP continue" })
    keymap(n, '<F6>', function() require('dap').step_over() end, { desc = "DAP step over" })
    keymap(n, '<F7>', function() require('dap').step_into() end, { desc = "DAP step into" })
    keymap(n, '<F8>', function() require('dap').step_out() end, { desc = "DAP step out" })
    keymap(n, '<Leader>dt', function() require('dap').toggle_breakpoint() end, { desc = "DAP toggle breakpoint" })
    keymap(n, '<Leader>dr', function() require('dap').repl.open() end, { desc = "DAP open REPL" })
    keymap(n, '<Leader>dl', function() require('dap').run_last() end, { desc = "DAP run last" })
    keymap(n, '<Leader>dc', function() require('dap').run_to_cursor() end, { desc = "DAP run to cursor" })
    keymap(n, '<Leader>dv', function() require('dap-view').toggle() end, { desc = "DAP toggle view" })
end

function M.neotest()
    keymap("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run nearest test" })
    keymap("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run test file" })
    keymap("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
    keymap("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, { desc = "Open test output" })
    keymap("n", "<leader>tp", function() require("neotest").output_panel.toggle() end, { desc = "Toggle output panel" })
    keymap("n", "<leader>tx", function() require("neotest").run.stop() end, { desc = "Stop test run" })
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
end

function M.command_aliases()
    vim.cmd("command! Wq wq")
    vim.cmd("command! W w")
    vim.cmd("command! Q q")
    vim.cmd("command! X x")
    vim.cmd("command! Xa xa")
end

return M
