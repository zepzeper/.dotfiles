local FFF = require("fff")

FFF.setup({
    prompt = "> ",
    layout = {
        height = 0.55,
        width = 0.95,
        prompt_position = "top",
        preview_position = "right",
        preview_size = 0.5,
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
