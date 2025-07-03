return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope",
  keys = {
    { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Find git files" },
    { "<C-n>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Grep string under cursor" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    
    telescope.setup({
      defaults = {
        -- Performance optimizations
        cache_picker = {
          num_pickers = 10,
          limit_entries = 1000,
        },
        dynamic_preview_title = true,
        winblend = 0, -- Fixed typo: was "winbled"
        
        -- Better file paths
        path_display = { 
          "truncate", -- More efficient than "smart"
          truncate = 3,
        },
        
        -- Faster sorting
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        
        -- Optimized mappings
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<ESC>"] = actions.close,
            ["<C-c>"] = actions.close,
          },
          n = {
            ["q"] = actions.close,
          },
        },
        
        -- Performance settings
        file_ignore_patterns = {
          "^.git/",
          "^node_modules/",
          "^target/",
          "%.o$",
          "%.a$",
          "%.out$",
          "%.class$",
          "%.pdf$",
          "%.mkv$",
          "%.mp4$",
          "%.zip$",
        },
      },
      
      pickers = {
        find_files = {
          -- Performance tweaks for file finding
          follow = true,
          hidden = false, -- Set to false by default for performance
          no_ignore = false, -- Respect .gitignore for performance
          find_command = { "rg", "--files", "--color", "never" }, -- Use ripgrep if available
        },
        live_grep = {
          -- Live grep optimizations
          additional_args = function(opts)
            return {"--hidden", "--smart-case"}
          end,
          glob_pattern = "!{.git,node_modules,target}/**",
        },
        buffers = {
          ignore_current_buffer = true,
          sort_lastused = true,
          sort_mru = true,
        },
        oldfiles = {
          cwd_only = true, -- Only show recent files from current working directory
        },
        grep_string = {
          additional_args = function(opts)
            return {"--hidden", "--smart-case"}
          end,
        },
      },
      
    })
    
    -- Additional optimized keymaps with better options
    local keymap = vim.keymap
    
    -- Project-wide search with better performance
    keymap.set("n", "<leader>fw", function()
      require("telescope.builtin").live_grep({
        prompt_title = "Live Grep (word boundaries)",
        additional_args = { "--word-regexp" },
      })
    end, { desc = "Live grep word boundaries" })
  end,
}
