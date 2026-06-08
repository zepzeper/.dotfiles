local group = vim.api.nvim_create_augroup("BlameStackTS", { clear = true })

-- vim.api.nvim_create_autocmd("BufWinEnter", {
--     group = group,
--     callback = function(ev)
--         local name = vim.api.nvim_buf_get_name(ev.buf)
--         if name:find("Blame stack", 1, true) then
--             local ft = vim.bo[ev.buf].filetype
--             if ft ~= "" then
--                 local ok, err = pcall(vim.treesitter.start, ev.buf, ft)
--                 vim.notify(ok and "TS started" or "TS error: " .. err)
--             end
--         end
--     end,
-- })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-view", "dap-repl" },
    callback = function()
        vim.wo.number = true
        vim.wo.relativenumber = true
    end,
})



vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    -- always attach for real languages, even in diff buffers
    if ev.match == "" then return end

    pcall(vim.treesitter.start, ev.buf, ev.match)
  end,
})
