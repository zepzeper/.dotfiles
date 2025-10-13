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
          keywords = 'italic,bold',
          types = 'NONE',
          functions = 'NONE',
          variables = 'NONE',
        },
      },
    })
    
    vim.cmd('colorscheme github_dark_dimmed')
    
  end,
}
