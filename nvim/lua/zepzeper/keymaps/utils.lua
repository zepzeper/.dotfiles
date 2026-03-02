local M = {}

function M.save_file()
    if vim.api.nvim_buf_get_option(0, "readonly") then
        return
    end
    local buftype = vim.api.nvim_buf_get_option(0, "buftype")
    if buftype == "nofile" or buftype == "prompt" then
        return
    end
    if vim.api.nvim_buf_get_option(0, "modifiable") then
        vim.cmd("w!")
    end
end

function M.toggle_diffview()
    local view = require("diffview.lib").get_current_view()
    if view then
        vim.cmd("DiffviewClose")
    else
        vim.cmd("DiffviewOpen")
    end
end

return M
