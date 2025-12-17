return {
  -- Add snacks.nvim separately
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
      notifier = { enabled = true },
    },
  },
  
  -- Your laravel.nvim config
  {
    'adibhanna/laravel.nvim',
    enabled = true,
    ft = { 'php', 'blade' },
    dependencies = {
      'folke/snacks.nvim',
    },
    config = function()
      require('laravel').setup({
        notifications = false,
        debug = false,
        keymaps = true,
        runner = {
          type = "docker_compose",
          options = {
            service = "app", -- Your service name
            compose_file = "docker-compose.yml",
          },
        },
      })
    end,
  },
}
