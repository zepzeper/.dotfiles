-- Task Runner: overseer.nvim
return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerShell", "OverseerTaskAction" },
    opts = {
      templates = { "builtin", "user" },
      task_list = {
        direction = "bottom",
        min_width = 40,
        max_width = 80,
        default_detail = 1,
      },
      confirm = {
        name = "default",
        params = "always",
      },
      form = {
        border = "rounded",
        win_opts = {},
      },
    },
    keys = {
      {
        "<M-o>r",
        function()
          local overseer = require("overseer")
          overseer.run_task({}, function(task)
            if task and not task:is_complete() then
              if not require("overseer.window").is_open() then
                overseer.open({ enter = false })
              end
            end
          end)
        end,
        desc = "Run Task",
      },
      { "<M-o>t", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
      { "<M-o>s", "<cmd>OverseerShell<cr>", desc = "Run Shell Command" },
      { "<M-o>a", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
    },
  },
}
