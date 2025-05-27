local augroup = vim.api.nvim_create_augroup
local yank_group = augroup('HighlightYank', {})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 150,  -- You can adjust this to how long you want the highlight to last
        })
    end,
})
