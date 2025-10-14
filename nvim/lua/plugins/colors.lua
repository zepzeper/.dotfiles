
return {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false,
  priority = 1000,
  config = function()
    require('github-theme').setup({
    })
    
    -- Use github_dark instead of github_dark_dimmed for better contrast
    vim.cmd('colorscheme github_dark')
  end,
}
