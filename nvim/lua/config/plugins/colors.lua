-- Function to apply a colorscheme and handle recoloring
local function apply_color(scheme)
  vim.cmd("colorscheme " .. scheme)

  -- Remove the background color to make it transparent
  vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])  -- Set the background to transparent for Neovim
  vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]]) -- Ensure normal window transparency for other windows
end

-- Define global functions for switching color schemes
_G.tokyo = function()
  apply_color("tokyonight")
end

_G.mellow = function()
  apply_color("mellow")
  vim.g.mellow_transparent = true
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

