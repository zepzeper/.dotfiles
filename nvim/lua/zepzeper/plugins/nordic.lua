require("nordic").load({
    swap_backgrounds = true,
    on_highlight = function(highlights, palette)
        highlights.WinBar = { bg = palette.bg, fg = palette.gray5 }
        highlights.WinBarNC = { bg = palette.bg, fg = palette.gray4 }
        highlights.TabLine = { bg = palette.bg, fg = palette.fg }
        highlights.TabLineFill = { bg = palette.bg, fg = palette.none }
    end,
    cursorline = {
        theme = "light",
    },
    telescope = {
        style = "classic",
    },
})

require("lualine").setup({
    options = { theme = "nordic" },
})
