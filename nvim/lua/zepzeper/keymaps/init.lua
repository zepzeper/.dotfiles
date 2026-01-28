-- I want to keep all of the key bindings in one file so that it is easy to see
-- what is being used and ensure nothing being overwritten by accident.
local n, i, v, c = "n", "i", "v", "c"
local ex_t = { n, i, v }
local n_i = { n, i }

local keymap = vim.keymap.set
local default_settings = { noremap = true, silent = true }

local M = {}

function M.init()
    M.editing()
    M.lsp()
    M.legacy() -- Keymaps migrated from old config
    M.git()
    M.blame()
    M.ninety_nine()
    M.harpoon()

    -- Lazyload dependents:
    M.telescope()
    M.no_neck_pain()
end

function M.harpoon()
    local harpoon = require("harpoon")
    local list = harpoon:list()

    -- Add file
    keymap("n", "<leader>a", function()
        list:add()
    end, { desc = "Harpoon add file" })

    -- Quick menu
    keymap("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(list)
    end, { desc = "Harpoon quick menu" })

    -- Navigate to files
    keymap("n", "<C-h>", function() list:select(1) end, { desc = "Harpoon file 1" })
    keymap("n", "<C-j>", function() list:select(2) end, { desc = "Harpoon file 2" })
    keymap("n", "<C-k>", function() list:select(3) end, { desc = "Harpoon file 3" })
    keymap("n", "<C-l>", function() list:select(4) end, { desc = "Harpoon file 4" })
end

function M.git()
    -- global mappings
    keymap("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })

    -- Diff mappings
    keymap("n", "gu", "<cmd>diffget //2<CR>", { desc = "Diff get left" })
    keymap("n", "gh", "<cmd>diffget //3<CR>", { desc = "Diff get right" })

    -- Fugitive-only mappings
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "fugitive",
        callback = function(ev)
            local opts = { buffer = ev.buf, desc = "Fugitive" }

            keymap("n", "<leader>p", function()
                vim.cmd.Git("push")
            end, vim.tbl_extend("force", opts, { desc = "Git push" }))

            keymap("n", "<leader>P", function()
                vim.cmd.Git({ "pull", "--rebase" })
            end, vim.tbl_extend("force", opts, { desc = "Git pull --rebase" }))

            keymap(
                "n",
                "<leader>t",
                ":Git push -u origin ",
                vim.tbl_extend("force", opts, { desc = "Git push upstream" })
            )
        end,
    })
end

function M.ninety_nine()
    keymap(n, "<leader>9f", function()
        require("99").fill_in_function()
    end, default_settings)
    keymap(v, "<leader>9v", function()
        require("99").visual()
    end, default_settings)
    keymap(v, "<leader>9s", function()
        require("99").stop_all_requests()
    end, default_settings)
end

function M.legacy()
    -- Disable Ctrl-c and Ctrl-z in normal mode
    keymap(n, "<C-c>", "<Nop>", default_settings)
    keymap(n, "<C-z>", "<Nop>", default_settings)

    -- Source and execute Lua
    keymap(n, "<space><space>x", "<cmd>source %<CR>", { desc = "Source current file" })
    keymap(n, "<space>x", ":.lua<CR>", { desc = "Execute line as Lua" })

    -- Jumping pages keeps cursor in the middle
    vim.keymap.set("n", "<C-u>", "<C-u>zz")
    vim.keymap.set("n", "<C-d>", "<C-d>zz")

    -- Keep search terms in the middle of the screen
    vim.keymap.set("n", "n", "nzzzv", { desc = "Jump to next search term" })
    vim.keymap.set("n", "N", "Nzzzv", { desc = "Jump to previous search term" })

    -- Move selected lines up/down
    keymap(v, "J", ":m '>+1<CR>gv=gv", default_settings)
    keymap(v, "K", ":m '<-2<CR>gv=gv", default_settings)

    -- Quickfix navigation with <C-c> prefix
    keymap(n, "<C-c>c", ":cclose<CR>", { desc = "Close quickfix" })
    keymap(n, "<C-c>o", ":copen<CR>", { desc = "Open quickfix" })
    keymap(n, "<C-c>n", ":cnext<CR>", { desc = "Next quickfix item" })
    keymap(n, "<C-c>p", ":cprev<CR>", { desc = "Previous quickfix item" })

    -- Paste without yanking (keeping register)
    keymap("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

    -- Toggle highlighting search
    keymap(n, "<leader>;h", ":set hlsearch!<CR>", { desc = "Toggle highlighting search" })

    -- Command aliases for common typos
    vim.cmd("command! Wq wq")
    vim.cmd("command! W w")
    vim.cmd("command! Q q")
    vim.cmd("command! X x")
    vim.cmd("command! Xa xa")

    -- Reload zemac plugin
    keymap(n, "<leader>rr", function()
        local plugin_name = "zemac"
        for module_name, _ in pairs(package.loaded) do
            if module_name:match("^" .. plugin_name) then
                package.loaded[module_name] = nil
            end
        end
        require("zemac").setup()
        vim.notify("zemac reloaded", vim.log.levels.WARN)
    end, { desc = "Reload zemac plugin" })

    -- Open corresponding header/source file
    keymap(n, "<leader>oh", function()
        vim.cmd.edit(vim.fn.expand("%:r") .. ".h")
    end, { desc = "Open header file" })
    keymap(n, "<leader>oc", function()
        vim.cmd.edit(vim.fn.expand("%:r") .. ".c")
    end, { desc = "Open source file" })
end

function M.lsp()
    keymap(n, "<leader>rn", function()
        pcall(vim.lsp.buf.rename)
    end, default_settings)

    keymap(n_i, "<C-\\>", function()
        pcall(vim.lsp.buf.signature_help)
    end, default_settings)

    keymap(n, "[e", function()
        require("zepzeper.native.lsp").prev_diag()
    end, default_settings)
    keymap(n, "]e", function()
        require("zepzeper.native.lsp").next_diag()
    end, default_settings)
    keymap(n, "[E", function()
        require("zepzeper.native.lsp").prev_error()
    end, default_settings)
    keymap(n, "]E", function()
        require("zepzeper.native.lsp").next_error()
    end, default_settings)

    -- Missing LSP keymaps from old config
    keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
    keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
    keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    keymap("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle Inlay Hints" })

    -- Diagnostic navigation aliases
    keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
    keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
    keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line Diagnostics" }) -- Alias to ge
end

function M.blame()
    keymap("n", "<leader>b", "<cmd>Git blame<CR>", { desc = "Git blame (fugitive)" })
end

function M.no_neck_pain()
    keymap(n, "<leader>n", require("zepzeper.plugins.no-neck-pain").toggle, default_settings)
end


function M.oil()
    keymap(n, "<leader>pv", function()
        require("zepzeper.keymaps.utils").toggle_oil()
    end)
    require("oil").setup({
        keymaps = {
            ["<CR>"] = "actions.select",
            ["-"] = "actions.parent",
        },
        use_default_keymaps = false,
    })
end

function M.editing()
    keymap(i, "<Esc>", "<Esc>`^", default_settings)
    keymap(ex_t, "<C-s>", function()
        require("zepzeper.keymaps.utils").save_file()
    end, default_settings)
    keymap(n, "<leader>v", function()
        require("zepzeper.keymaps.utils").toggle_diffview()
    end)
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
    keymap(n, "<leader>fh", function()
        require("telescope.builtin").help_tags({})
    end, { desc = "Help tags" })
    keymap(n, "<leader>fm", function()
        require("telescope.builtin").man_pages({ sections = { "ALL" } })
    end, { desc = "Man pages" })

    -- Edit Neovim config
    keymap(n, "<leader>en", function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Edit Neovim config" })

    -- Knowledge Garden keymaps
    local kg_path = vim.fn.expand("~/knowledge-garden")
    keymap(n, "<leader>kf", function()
        require("telescope.builtin").find_files({
            cwd = kg_path,
            prompt_title = "Notes",
        })
    end, { desc = "Find note" })
    keymap(n, "<leader>ks", function()
        require("telescope.builtin").live_grep({
            cwd = kg_path,
            prompt_title = "Search notes",
        })
    end, { desc = "Search notes" })

    -- Additional telescope keymaps
    keymap(n, "z=", function()
        require("telescope.builtin").spell_suggest({})
    end)
    keymap(n, "<leader>fk", function()
        require("telescope.builtin").keymaps({})
    end, { desc = "Keymaps" })

    keymap(n, "<C-n>", "<Cmd>Telescope buffers previewer=false<CR>", default_settings)
    keymap(n, "<leader>E", "<Cmd>Telescope diagnostics line_width=full bufnr=0<CR>", { desc = "Buffer diagnostics" })

    -- TODO: I don't want this to jump if there is only one entry.
    keymap(n, "gr", "<Cmd>Telescope lsp_references<CR>", default_settings)
    keymap(n, "gd", "<Cmd>Telescope lsp_definitions<CR>", default_settings)
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

    keymap(c, "<C-Space>", function()
        require("cmp").complete()
    end, default_settings)
end

return M
