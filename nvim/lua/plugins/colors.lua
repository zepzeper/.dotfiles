
return {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false,
  priority = 1000,
  config = function()
    require('github-theme').setup({
      options = {
        transparent = false,
        styles = {
          comments = 'italic',
          keywords = 'bold',
          types = 'NONE',
          functions = 'NONE',
          variables = 'NONE',
        },
      },
      palettes = {
        github_dark_dimmed = {
          -- Keep GitHub's colors but make them more distinct
        },
      },
    })
    
    -- Use github_dark instead of github_dark_dimmed for better contrast
    vim.cmd('colorscheme github_dark')
  end,
}
