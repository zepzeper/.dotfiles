local char = "┆"

require("ibl").setup({
    exclude = {
        filetypes = { "NvimTree", "startify", "dashboard", "help", "markdown" },
    },
    scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        char = char,
        highlight = "IblScope",  -- Changed from IndentBlanklineContextChar
    },
    indent = {
        char = char,
        highlight = "IblIndent",  -- Changed from IndentBlanklineChar
    },
})
