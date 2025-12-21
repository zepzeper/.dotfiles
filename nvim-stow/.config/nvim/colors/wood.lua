local M = {}

M.setup = function()
    vim.g.colors_name = "wood"

    -- Color palette
    local colors = {
        bg = '#000000',
        fg = '#fefae0',

        black = '#151c0d',
        red = '#bc6c25',
        green = '#606c38',
        yellow = '#dda15e',
        blue = '#dda15e',
        magenta = '#bc6c25',
        cyan = '#606c38',
        white = '#fefae0',

        bright_black = '#151c0d',
        bright_red = '#bc6c25',
        bright_green = '#606c38',
        bright_yellow = '#dda15e',
        bright_blue = '#dda15e',
        bright_magenta = '#bc6c25',
        bright_cyan = '#606c38',
        bright_white = '#fefae0',

        comment = '#8d936a',
    }

    -- Vim editor colors
    vim.cmd("highlight clear")
    vim.o.termguicolors = true

    -- General
    vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
    -- Assuming gray1 is a good comment color
    vim.api.nvim_set_hl(0, "Comment", { fg = colors.comment })
    vim.api.nvim_set_hl(0, "Constant", { fg = colors.magenta })
    vim.api.nvim_set_hl(0, "String", { fg = colors.green })
    vim.api.nvim_set_hl(0, "Character", { fg = colors.green })
    vim.api.nvim_set_hl(0, "Number", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "Boolean", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "Float", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "Identifier", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Function", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Statement", { fg = colors.red })
    vim.api.nvim_set_hl(0, "Conditional", { fg = colors.red })
    vim.api.nvim_set_hl(0, "Repeat", { fg = colors.red })
    vim.api.nvim_set_hl(0, "Label", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "Operator", { fg = colors.cyan })
    vim.api.nvim_set_hl(0, "Keyword", { fg = colors.red })
    vim.api.nvim_set_hl(0, "Exception", { fg = colors.red })
    vim.api.nvim_set_hl(0, "PreProc", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "Include", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Define", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "Macro", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "PreCondit", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "Type", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "StorageClass", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "Structure", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "Typedef", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "Special", { fg = colors.cyan })
    vim.api.nvim_set_hl(0, "SpecialChar", { fg = colors.cyan })
    vim.api.nvim_set_hl(0, "Tag", { fg = colors.cyan })
    vim.api.nvim_set_hl(0, "Delimiter", { fg = colors.cyan })
    vim.api.nvim_set_hl(0, "SpecialComment", { fg = colors.cyan })
    vim.api.nvim_set_hl(0, "Debug", { fg = colors.red })
    vim.api.nvim_set_hl(0, "Underlined", { underline = true })
    vim.api.nvim_set_hl(0, "Bold", { bold = true })
    vim.api.nvim_set_hl(0, "Italic", { italic = true })
    vim.api.nvim_set_hl(0, "Error", { fg = colors.red, bg = colors.bg })
    vim.api.nvim_set_hl(0, "Todo", { fg = colors.yellow, bg = colors.bg })

    -- UI
    vim.api.nvim_set_hl(0, "LineNr", { fg = colors.comment })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.fg, bold = true })
    vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = colors.bg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.black, bg = colors.bg })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = colors.black, bg = colors.bg })
    vim.api.nvim_set_hl(0, "Folded", { fg = colors.black, bg = colors.bg })
    vim.api.nvim_set_hl(0, "FoldColumn", { fg = colors.black, bg = colors.bg })
    vim.api.nvim_set_hl(0, "SignColumn", { fg = colors.black, bg = colors.bg })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = colors.black })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.black })
    vim.api.nvim_set_hl(0, "MatchParen", { fg = colors.red, bold = true })
    vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.fg, bg = colors.bg })
    vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.bg, bg = colors.fg })
    vim.api.nvim_set_hl(0, "PmenuSbar", { bg = colors.black })
    vim.api.nvim_set_hl(0, "PmenuThumb", { bg = colors.fg })
    vim.api.nvim_set_hl(0, "Visual", { bg = colors.bright_cyan })
    vim.api.nvim_set_hl(0, "VisualNOS", { bg = colors.bright_cyan })
    vim.api.nvim_set_hl(0, "Search", { fg = colors.bg, bg = colors.yellow })
    vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.bg, bg = colors.yellow })
    vim.api.nvim_set_hl(0, "NonText", { fg = colors.black })
    vim.api.nvim_set_hl(0, "SpecialKey", { fg = colors.black })
    vim.api.nvim_set_hl(0, "Directory", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "ErrorMsg", { fg = colors.red, bg = colors.bg })
    vim.api.nvim_set_hl(0, "WarningMsg", { fg = colors.yellow, bg = colors.bg })
    vim.api.nvim_set_hl(0, "MoreMsg", { fg = colors.green })
    vim.api.nvim_set_hl(0, "Question", { fg = colors.green })
    vim.api.nvim_set_hl(0, "Title", { fg = colors.magenta, bold = true })
    vim.api.nvim_set_hl(0, "Conceal", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "SpellBad", { sp = colors.red, undercurl = true })
    vim.api.nvim_set_hl(0, "SpellCap", { sp = colors.blue, undercurl = true })
    vim.api.nvim_set_hl(0, "SpellRare", { sp = colors.magenta, undercurl = true })
    vim.api.nvim_set_hl(0, "SpellLocal", { sp = colors.cyan, undercurl = true })
    vim.api.nvim_set_hl(0, "Cursor", { fg = colors.bg, bg = colors.fg })
    vim.api.nvim_set_hl(0, "lCursor", { fg = colors.bg, bg = colors.fg })
    vim.api.nvim_set_hl(0, "TermCursor", { fg = colors.bg, bg = colors.fg })
    vim.api.nvim_set_hl(0, "TermCursorNC", { fg = colors.bg, bg = colors.black })
end

return M
