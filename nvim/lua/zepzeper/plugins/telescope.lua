local TS = require("telescope")
local U = require("zepzeper.utils")
----------------------------------------------------------------------------------------------------
--- Defaults
local actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")
local ACTIONS = {
    ["<Esc>"] = actions.close,
    ["<C-Esc>"] = actions.close,
    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
}
local MAPPINGS = {
    i = ACTIONS,
    n = ACTIONS,
}
----------------------------------------------------------------------------------------------------
--- Templates.
local baseline = {
    previewer = true,
    layout_strategy = "horizontal",
    layout_config = {
        anchor = "S",
        height = 0.55,
        width = 1000,
        prompt_position = "top",
    },
    border = true,
    borderchars = {
        prompt = U.border_chars_telescope_combine_top,
        results = U.border_chars_telescope_combine_bottom,
        preview = U.border_chars_telescope_default,
    },
    hl_result_eol = true,
    wrap_results = false,
    winblend = 0,
    mappings = MAPPINGS,
    preview = { treesitter = true },
}
local ui_select_theme = {
    layout_strategy = "center",
    layout_config = {},
}
----------------------------------------------------------------------------------------------------
--- Configure
TS.setup({
    defaults = baseline,
    extensions = {
        ["ui-select"] = ui_select_theme,
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        live_grep_args = U.merge(baseline, {
            auto_quoting = true, -- quotes search term so trailing tokens become rg args
            mappings = {
                i = U.merge(ACTIONS, {
                    -- wrap current prompt in quotes (lets you start adding args)
                    ["<C-k>"] = lga_actions.quote_prompt(),
                    -- quote + append a file glob:  "<search>" --iglob *
                    ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                    -- quote + append a directory glob: "<search>" --iglob **/
                    ["<C-d>"] = lga_actions.quote_prompt({ postfix = " --iglob **/" }),
                    -- freeze grep results, then fuzzy-filter them (the "subquery")
                    ["<C-space>"] = lga_actions.to_fuzzy_refine,
                }),
                n = ACTIONS,
            },
        }),
    },
    pickers = {
        lsp_code_actions = baseline,
        -- Bottom small pickers
        oldfiles = baseline,
        find_files = baseline,
        registers = baseline,
        -- Vertical preview pickers
        jumplist = baseline,
        highlights = baseline,
        live_grep = baseline,
        lsp_references = baseline,
        lsp_definitions = baseline,
        lsp_implementations = baseline,
        diagnostics = baseline,
        lsp_document_symbols = U.merge(baseline, {
            symbol_width = 0.75,
        }),
        -- Custom
        help_tags = U.merge(baseline, {
            prompt_title = "Neovim help",
            mappings = { i = { ["<CR>"] = actions.select_vertical } },
        }),
        buffers = U.merge(baseline, {
            ignore_current_buffer = true,
            file_ignore_patterns = {
                "%.git/",
                "node_modules/",
            },
            on_complete = {
                function(picker)
                    vim.schedule(function()
                        picker:set_selection(0)
                    end)
                end,
            },
        }),
        man_pages = U.merge(baseline, {
            prompt_title = "Manpages",
            mappings = { i = { ["<CR>"] = actions.select_vertical } },
        }),
    },
})
TS.load_extension("ui-select")
TS.load_extension("fzf")
TS.load_extension("live_grep_args")

vim.keymap.set("n", "<leader>fg", function()
    require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Live grep (args)" })

vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function()
        vim.opt_local.number = true
    end,
})
