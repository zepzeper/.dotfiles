require("zepzeper.native.lsp.defaults")

local M = {}

local U = require("zepzeper.utils")

-- Enable logging.
vim.lsp.log.set_level("error")

local float_options = {
    border = U.border_chars_round,
    prefix = "  ",
    header = "",
    severity_sort = true,
}

function M.open_diagnostics_float()
    vim.diagnostic.open_float(float_options)
end

function M.next_error()
    vim.diagnostic.jump({
        count = 1,
        severity = vim.diagnostic.severity.ERROR,
        float = float_options,
    })
end

function M.prev_error()
    vim.diagnostic.jump({
        count = -1,
        severity = vim.diagnostic.severity.ERROR,
        float = float_options,
    })
end

function M.next_diag()
    vim.diagnostic.jump({
        count = 1,
        float = float_options,
    })
end

function M.prev_diag()
    vim.diagnostic.jump({
        count = -1,
        float = float_options,
    })
end

return M
