return {
  {
    'adibhanna/laravel.nvim',
    ft = { 'php', 'blade' },
    config = function()
      require('laravel').setup({
        notifications = true,
        debug = true,
        keymaps = true
      })
    end,
  },
}
