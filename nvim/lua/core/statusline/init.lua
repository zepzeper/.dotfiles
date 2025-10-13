local M = {}

local function get_venv(variable)
  local venv = os.getenv(variable)
  if venv ~= nil and string.find(venv, "/") then
    local orig_venv = venv
    for w in orig_venv:gmatch "([^/]+)" do
      venv = w
    end
    venv = string.format("%s", venv)
  end
  return venv
end

M.harpoon = function()
  local ok, harpoon = pcall(require, "harpoon")
  if not ok then
    return ""
  end
  
  local options = {
    icon = "󰀱 ",
    indicators = { "1", "2", "3", "4" },
    active_indicators = { "[1]", "[2]", "[3]", "[4]" },
    separator = " ",
  }
  
  local list = harpoon:list()
  local root_dir = list.config:get_root_dir()
  local current_file_path = vim.api.nvim_buf_get_name(0)
  local length = math.min(list:length(), #options.indicators)
  local status = {}
  
  local get_full_path = function(root, value)
    if root == nil or value == nil then
      return ""
    end
    return root .. "/" .. value
  end
  
  for i = 1, length do
    local item = list:get(i)
    if item then
      local value = item.value
      local full_path = get_full_path(root_dir, value)
      if full_path == current_file_path then
        table.insert(status, options.active_indicators[i])
      else
        table.insert(status, options.indicators[i])
      end
    end
  end
  
  if #status == 0 then
    return ""
  end
  
  return options.icon .. table.concat(status, options.separator)
end

M.python_venv = function()
  if vim.bo.filetype ~= "python" then
    return ""
  end
  
  local venv = get_venv "CONDA_DEFAULT_ENV" or get_venv "VIRTUAL_ENV"
  if venv == nil or venv == "" then
    return ""
  else
    return "  " .. venv
  end
end

M.clients = function()
  local clients = {}
  local buf = vim.api.nvim_get_current_buf()
  
  -- Get LSP clients
  for _, client in pairs(vim.lsp.get_clients { bufnr = buf }) do
    table.insert(clients, client.name)
  end
  
  -- Get linters
  local lint_ok, lint = pcall(require, "lint")
  if lint_ok then
    local linters = lint.linters_by_ft[vim.bo.filetype] or {}
    for _, linter in ipairs(linters) do
      if not vim.tbl_contains(clients, linter) then
        table.insert(clients, linter)
      end
    end
  end
  
  -- Get formatters
  local conform_ok, conform = pcall(require, "conform")
  if conform_ok then
    local formatters = conform.list_formatters(0)
    for _, formatter in pairs(formatters) do
      if not vim.tbl_contains(clients, formatter.name) then
        table.insert(clients, formatter.name)
      end
    end
  end
  
  if #clients == 0 then
    return ""
  else
    -- Show full list if screen is wide enough, otherwise just "LSP"
    return (vim.o.columns > 100 and ("󰒋 " .. table.concat(clients, ", "))) or "󰒋 LSP"
  end
end

M.total_lines = function()
  return tostring(vim.api.nvim_buf_line_count(0)) .. "L"
end

M.git_branch = function()
  local handle = io.popen("git branch --show-current 2>/dev/null")
  if not handle then
    return ""
  end
  local branch = handle:read("*a")
  handle:close()
  if branch and branch ~= "" then
    branch = branch:gsub("\n", "")
    return "󰊢 " .. branch
  end
  return ""
end

return M
