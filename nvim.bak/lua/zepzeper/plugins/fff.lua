local FFF = require("fff")

FFF.setup({
    prompt = "> ",
    layout = {
        height = 0.45,
        width = 1.0,
        anchor = "bottom",          -- ← was `position = "bottom"` (not a real key)
        prompt_position = "bottom",
        preview_position = "right",
    },
    keymaps = {
        close = "<Esc>",
        select = "<CR>",
        select_split = "<C-s>",
        select_vsplit = "<C-v>",
        select_tab = "<C-t>",
        move_up = { "<Up>", "<C-p>" },
        move_down = { "<Down>", "<C-n>" },
        preview_scroll_up = "<C-u>",
        preview_scroll_down = "<C-d>",
        toggle_select = "<Tab>",
        send_to_quickfix = "<C-q>",
        cycle_grep_modes = "<S-Tab>",
    },
    preview = {
        line_numbers = true,
    },
})

vim.api.nvim_create_autocmd("User", {
    pattern = "FFFPreviewerLoaded",
    callback = function()
        vim.opt_local.number = true
    end,
})
