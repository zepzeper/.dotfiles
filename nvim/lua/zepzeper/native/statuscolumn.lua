local M = {}

vim.opt.signcolumn = "yes"

-- Signs first, right aligned relative number
function M.signs_right_align()
    vim.opt.numberwidth = 5
    vim.opt.statuscolumn = " %s%=%{v:relnum?v:relnum:v:lnum}%#WinSeparator#  "
end

-- Statuscolumn was added in 0.9.
if vim.version.major == 0 and vim.version.minor < 9 then
    -- Fallback for when cannot set custom statuscolumn.
    vim.opt.relativenumber = true
    vim.opt.number = true
    vim.opt.signcolumn = "yes"
else
    M.signs_right_align()
end

return M
