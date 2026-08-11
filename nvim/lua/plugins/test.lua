return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "antoinemadec/FixCursorHold.nvim",
    "olimorris/neotest-phpunit",
    "praem90/neotest-docker-phpunit.nvim",
  },
  config = function()
    local phpunit = require("neotest-phpunit")({
      root_files = { "composer.json", "phpunit.xml.dist", ".gitignore" },
    })

    require("neotest").setup({
      adapters = { phpunit },
    })


    local original_build_spec = phpunit.build_spec

    local function get_phpunit_config(path)
      if not path then
        return "/data/www/useracademy/codebase/tools/phpunit/unit/phpunit.xml.dist"
      end
      local ok, lines = pcall(vim.fn.readfile, path)
      if ok then
        local content = table.concat(lines, "\n")
        if content:match("#%[Group%(['\"]integration['\"]%)%]") then
          return "/data/www/useracademy/codebase/tools/phpunit/integration/phpunit.xml.dist"
        end
      end
      return "/data/www/useracademy/codebase/tools/phpunit/unit/phpunit.xml.dist"
    end

    phpunit.build_spec = function(args)
      local spec = original_build_spec(args)
      if not spec then return nil end

      local path = args.tree and args.tree:data().path
      local config = get_phpunit_config(path)

      -- rewrite --log-junit to container volume path
      for i, arg in ipairs(spec.command) do
        if type(arg) == "string" and arg:match("^--log%-junit=") then
          local host_path = arg:match("^--log%-junit=(.+)$")
          local container_path = host_path:gsub("^/tmp/", "/data/www/useracademy/codebase/.phpunit.cache/neotest-")
          spec.command[i] = "--log-junit=" .. container_path
          spec.context.results_path = container_path:gsub(
            "^/data/www/useracademy/codebase",
            "/data/probase.git"
          )
          break
        end
      end

      -- rewrite host paths to container paths
      for i, arg in ipairs(spec.command) do
        if type(arg) == "string" and arg:match("^/data/probase%.git") then
          spec.command[i] = arg:gsub("^/data/probase%.git", "/data/www/useracademy/codebase")
        end
      end

      -- prepend docker exec with the correct config
      spec.command = vim.tbl_flatten({
        "docker", "exec", "probase-webserver",
        "php", "/data/www/useracademy/codebase/vendor/bin/phpunit",
        "--configuration", config,
        vim.list_slice(spec.command, 2),
      })

      return spec
    end


    vim.keymap.set("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run test file" })
    vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
    vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, { desc = "Open test output" })
    vim.keymap.set("n", "<leader>tp", function() require("neotest").output_panel.toggle() end, { desc = "Toggle output panel" })
    vim.keymap.set("n", "<leader>tx", function() require("neotest").run.stop() end, { desc = "Stop test run" })

  end,
}
