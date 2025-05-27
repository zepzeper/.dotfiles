local set = vim.opt;

set.guicursor = ""

set.nu = true
set.relativenumber = true

-- Default tab settings (fallback if .editorconfig isn't applied)
set.tabstop = 2
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true

vim.opt.autoindent = true   -- Maintain indentation
vim.opt.smartindent = true  -- Context-aware indentation

set.wrap = false

set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

set.hlsearch = false
set.incsearch = true

set.termguicolors = true

set.scrolloff = 8
set.signcolumn = "yes"
set.isfname:append("@-@")

set.updatetime = 50
