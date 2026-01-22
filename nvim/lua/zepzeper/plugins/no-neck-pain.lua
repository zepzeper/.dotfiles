local M = {}

M.enabled = false

function M.setup()
    require("no-neck-pain").setup({
        width = 120,
    })
end

function M.toggle()
    M.enabled = not M.enabled
    vim.cmd("NoNeckPain")
    require("zepzeper.plugins.lualine").refresh_statusline()
end

return M
