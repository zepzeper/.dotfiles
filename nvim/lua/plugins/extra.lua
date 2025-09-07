return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
  {
    "stevearc/dressing.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    config = function()
      require("dressing").setup()
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      local comment = require("Comment")

      local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

      comment.setup({
        pre_hook = ts_context_commentstring.create_pre_hook(),
      })
    end,
  },
  {
    "numToStr/FTerm.nvim",
    config = function()
      vim.api.nvim_create_user_command('FTermToggle', function()
        require('FTerm').toggle()
      end, { bang = true })

      vim.keymap.set('n', '<leader>tt', '<cmd>FTermToggle<CR>', { desc = 'Toggle terminal' })
      vim.keymap.set('t', '<leader>tt', '<C-\\><C-n><cmd>FTermToggle<CR>', { desc = 'Toggle terminal (from terminal)' })
    end
  }
}
