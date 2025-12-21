vim.g.mapleader = " "

require("core.lazy")
require("core.lsp")

require("config.keymaps")
require("config.options")
require("config.autocmd")
require("config.health-check")
require("config.ft")

vim.cmd('colorscheme wood')

-- vim.cmd.colorscheme("telemetry")
