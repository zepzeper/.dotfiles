-- Debugging: DAP configuration
return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      local dap = require("dap")

      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { "/home/wouter/personal/vscode-php-debug/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          name = "Listen (Remote)",
          type = "php",
          request = "launch",
          port = 9000,
        },
        {
          name = "Listen (Local)",
          type = "php",
          request = "launch",
          port = 9003,
        },
      }

      vim.fn.sign_define("DapBreakpoint", { text = "●" })

      dap.listeners.before.attach.dap_view = function()
        require("dap-view").open()
      end
      dap.listeners.before.launch.dap_view = function()
        require("dap-view").open()
      end
      dap.listeners.before.event_terminated.dap_view = function()
        require("dap-view").close()
      end
      dap.listeners.before.event_exited.dap_view = function()
        require("dap-view").close()
      end
    end,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
      { "<F6>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<F7>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<F8>", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    },
  },
  {
    "igorlfs/nvim-dap-view",
    lazy = true,
    config = function()
      require("dap-view").setup({
        winbar = {
          sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
          controls = { enabled = true, position = "left" },
        },
        windows = {
          position = "right",
          size = 0.3,
          terminal = {
            position = "below",
          },
        },
      })
    end,
    keys = {
      { "<leader>dv", function() require("dap-view").toggle() end, desc = "Toggle View" },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    opts = {},
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    lazy = true,
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "php-debug-adapter" },
      automatic_installation = true,
      handlers = {
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },
}
