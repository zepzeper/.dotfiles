require("zepzeper.loader.bootstrap")

local plugins = require("zepzeper.loader.plugins")

local opts = {
    ui = { border = "rounded" },
    defaults = { lazy = false },
    checker = {
        notify = false,
        enabled = true,
    },
}

require("lazy").setup(plugins, opts)
