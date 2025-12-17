-- util/lsp_notify.lua
local M = {}

-- Map our levels to vim.log.levels (and optionally icons)
local icons = {
  info  = "ℹ️",
  warn  = "⚠️",
  error = "❗",
  debug = "🐞",
}

-- title (string), msg (string), level = "info" | "warn" | "error" | ...
-- opts = optional table (e.g. { timeout = 5000, replace = some_id, etc. })
function M.notify(title, msg, level, opts)
  opts = opts or {}
  local notify_opts = {
    title = title,
    level = vim.log.levels[level:upper()] or vim.log.levels.INFO,
    -- you can add other options like timeout, replace, etc.
  }
  -- Use an icon + space + message
  local full_msg = (icons[level] or "") .. " " .. msg
  vim.notify(full_msg, notify_opts.level, vim.tbl_extend("force", notify_opts, opts))
end

-- convenience aliases
function M.info(title, msg, opts)  M.notify(title, msg, "info", opts)  end
function M.warn(title, msg, opts)  M.notify(title, msg, "warn", opts)  end
function M.error(title, msg, opts) M.notify(title, msg, "error", opts) end

return M
