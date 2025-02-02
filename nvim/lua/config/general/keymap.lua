-- Netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")

-- Jumping pages keeps cursor in the middle
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Keep search terms in the middle of the screen
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Jump to next search term' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Jump to previous search term' })

-- when selected move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Replace under cursor in whole buffer
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Pastes copied buffer and keeps it in the register
vim.keymap.set('x', '<leader>p', '\"_dP')

-- Toggle highlighting search
vim.keymap.set('n', '<leader>;h', ':set hlsearch!<CR>', { desc = 'Toggle highlighting search' })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- :Wq, Xa, etc. remaps
vim.cmd("command! Wq wq")
vim.cmd("command! W w")
vim.cmd("command! Q q")
vim.cmd("command! X x")
vim.cmd("command! Xa xa")

-- FullScreen
vim.api.nvim_set_keymap('n', '<leader>fs', '<C-w>|', { noremap = true, silent = true })
-- ExitFullscreen
vim.api.nvim_set_keymap('n', '<leader>rs', '<C-w>=', { noremap = true, silent = true })

vim.opt.clipboard = "unnamedplus"
vim.g.python3_host_prog = '/opt/homebrew/bin/python3'
