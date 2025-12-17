-- Map Ctrl-c in normal mode to not act like Esc
vim.keymap.set("n", "<C-c>", "<Nop>")

-- Netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Netrw file explorer" })

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<space>x", ":.lua<CR>", { desc = "Execute line as Lua" })

-- Jumping pages keeps cursor in the middle
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Keep search terms in the middle of the screen
vim.keymap.set("n", "n", "nzzzv", { desc = "Jump to next search term" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Jump to previous search term" })

-- when selected move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Then use it as a prefix
vim.keymap.set("n", "<C-c>c", ":cclose<CR>", { desc = "Close quickfix" })
vim.keymap.set("n", "<C-c>o", ":copen<CR>", { desc = "Open quickfix" })
vim.keymap.set("n", "<C-c>n", ":cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-c>p", ":cprev<CR>", { desc = "Previous quickfix item" })

-- Replace under cursor in whole buffer
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

-- Pastes copied buffer and keeps it in the register
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Toggle highlighting search
vim.keymap.set("n", "<leader>;h", ":set hlsearch!<CR>", { desc = "Toggle highlighting search" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })

-- :Wq, Xa, etc. remaps
vim.cmd("command! Wq wq")
vim.cmd("command! W w")
vim.cmd("command! Q q")
vim.cmd("command! X x")
vim.cmd("command! Xa xa")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
