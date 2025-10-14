-- Statusline matching the second reference image
local M = {}

-- Get full mode name
function _G.get_mode_name()
    local mode_map = {
        n = 'NORMAL',
        i = 'INSERT',
        v = 'VISUAL',
        V = 'V-LINE',
        [''] = 'V-BLOCK',
        c = 'COMMAND',
        R = 'REPLACE',
        Rv = 'V-REPLACE',
        s = 'SELECT',
        S = 'S-LINE',
        [''] = 'S-BLOCK',
        t = 'TERMINAL',
    }
    local mode = vim.fn.mode()
    return mode_map[mode] or 'NORMAL'
end

-- Git branch with icon
function _G.get_git_branch()
    local handle = io.popen("git branch --show-current 2>/dev/null")
    if not handle then return '' end
    
    local branch = handle:read("*a")
    handle:close()
    
    if branch and branch ~= "" then
        branch = branch:gsub("\n", "")
        local git_icon = ''  -- nf-dev-git
        return ' ' .. git_icon .. ' ' .. branch
    end
    return ''
end

-- File icon based on extension
function _G.get_file_icon()
    local ext = vim.fn.expand('%:e')
    local icons = {
        git = '',
        java = '',
        js = '',
        ts = '',
        jsx = '',
        tsx = '',
        lua = '',
        py = '',
        php = '',
        html = '',
        css = '',
        json = '',
        md = '',
        go = '',
        rs = '',
        vim = '',
    }
    return icons[ext] or ''
end

-- Modified indicator (circle icons)
function _G.get_modified()
    if vim.bo.modified then
        return '●'
    end
    return '○'
end

-- Tab/window indicators
function _G.get_indicators()
    -- You can customize this logic based on your needs
    -- For now, showing tab count and window count
    local tabcount = vim.fn.tabpagenr('$')
    local wincount = vim.fn.winnr('$')
    return string.format('  %d  %d', tabcount, wincount)
end

-- Right side info
function _G.get_right_info()
    local parts = {}
    
    -- Add framework/project type detection and LSP clients
    local tech_parts = {}
    local cwd = vim.fn.getcwd()
    if vim.fn.filereadable(cwd .. '/pom.xml') == 1 then
        table.insert(tech_parts, 'spring-boot')
    end
    
    -- Add LSP clients
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
        table.insert(tech_parts, client.name)
    end
    
    if #tech_parts > 0 then
        table.insert(parts, table.concat(tech_parts, ', '))
    end
    
    local result = table.concat(parts, '  ')
    return result
end

-- Project name for red section
function _G.get_project_name()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end

-- Setup
function M.setup()
    -- Exact layout from reference image
    vim.opt.statusline = table.concat({
        '%#StatusLineMode#',              -- Mode color (blue background)
        ' %{v:lua.get_mode_name()} ',     -- Full mode name (NORMAL, INSERT, etc)
        '%#StatusLine#',                  -- Regular statusline
        ' %{v:lua.get_file_icon()} ',     -- File icon
        '%t',                             -- Filename
        ' %#StatusLineGit#',              -- Git section color
        '%{v:lua.get_git_branch()}',      -- Git branch with icon
        '%#StatusLine#',                  -- Back to regular
        '%=',                             -- Right align
        ' %{v:lua.get_right_info()}',     -- Right side tags
        ' %#StatusLineProject#',          -- Project name section (red)
        '  %{v:lua.get_project_name()} ', -- Project name with folder icon
        '%#StatusLine#',                  -- Back to regular
        ' %l ',                           -- Line number with padding
    })
    
    vim.opt.laststatus = 3
    
    -- Mode colors - solid background with contrasting text
    local function update_mode_color()
        local mode = vim.fn.mode()
        local colors = {
            n = { bg = "#58a6ff", fg = "#0d1117" },  -- Blue bg, dark text
            i = { bg = "#3fb950", fg = "#0d1117" },  -- Green bg, dark text
            v = { bg = "#d29922", fg = "#0d1117" },  -- Yellow bg, dark text
            V = { bg = "#d29922", fg = "#0d1117" },
            [""] = { bg = "#d29922", fg = "#0d1117" },
            c = { bg = "#f85149", fg = "#ffffff" },  -- Red bg, white text
            R = { bg = "#f85149", fg = "#ffffff" },
            t = { bg = "#bc8cff", fg = "#0d1117" },  -- Purple bg, dark text
        }
        local color = colors[mode] or { bg = "#58a6ff", fg = "#0d1117" }
        vim.api.nvim_set_hl(0, "StatusLineMode", { bg = color.bg, fg = color.fg, bold = true })
    end
    
    -- Highlight groups
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#0d1117", fg = "#8b949e" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#0d1117", fg = "#6e7681" })
    vim.api.nvim_set_hl(0, "StatusLineGit", { bg = "#0d1117", fg = "#8b949e" })
    vim.api.nvim_set_hl(0, "StatusLineProject", { bg = "#f85149", fg = "#ffffff", bold = true })
    
    -- Update events
    vim.api.nvim_create_autocmd({ "ModeChanged", "LspAttach", "LspDetach", "BufEnter", "BufWritePost" }, {
        callback = function()
            update_mode_color()
            vim.cmd.redrawstatus()
        end,
    })
    
    update_mode_color()
end

return M
