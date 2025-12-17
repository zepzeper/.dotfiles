return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.expand("~/knowledge-garden") .. "/*.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "nvim-treesitter/nvim-treesitter",
  },

  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/knowledge-garden",
      },
    },

    mappings = {

      -- Follow link under cursor (like LSP "gd")
      ["gd"] = {
        action = function()
          vim.cmd("ObsidianFollowLink")
        end,
        opts = { noremap = true, silent = true, buffer = true },
      },

      -- Backlinks (like "gr")
      ["gr"] = {
        action = function()
          vim.cmd("ObsidianBacklinks")
        end,
        opts = { noremap = true, silent = true, buffer = true },
      },

      ["<leader>p"] = {
        action = function()
          vim.cmd("ObsidianPasteImg")
        end,
        opts = { noremap = true, silent = true, buffer = true },
      },

      -- Rename note (LSP-style rename)
      ["<leader>rn"] = {
        action = function()
          vim.cmd("ObsidianRename")
        end,
        opts = { noremap = true, silent = true, buffer = true },
      },
    },
  },
}
