return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      local mellow = require("lualine.themes.tokyonight")

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = mellow,
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { "filename" },
          lualine_x = {
            {
              "diagnostics",
              sections = { "error", "warn" },
              symbols = { error = " ", warn = " " },
              colored = true,
              update_in_insert = false,
              always_visible = true,
            },
            {
              function()
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nil then
                  return "None"
                end
                local client_names = {}
                for _, client in pairs(clients) do
                  table.insert(client_names, client.name)
                end
                return "  : " .. table.concat(client_names, ", ")
              end,
            },
          },
          lualine_y = { "encoding" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
}
