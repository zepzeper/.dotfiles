-- Function to apply a colorscheme and handle recoloring
local function apply_color(scheme)
  vim.cmd("colorscheme " .. scheme)
end

-- Define global functions for switching color schemes
_G.tokyo = function()
  apply_color("tokyonight")
end

_G.mellow = function()
  apply_color("mellow")
end

return {
  -- Install the tokyonight theme
  {
    "folke/tokyonight.nvim",
    config = function()
    end,
  },

  -- Install the mellow theme
  {
    "mellow-theme/mellow.nvim",
    config = function()
      -- Default colorscheme
      apply_color("mellow")
    end,
  },
}

