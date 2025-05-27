return {
  {
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require("luasnip")

      -- Key mappings for expanding and navigating snippets.
      vim.keymap.set({ "i" }, "<C-b>", function() ls.expand() end, { silent = true, desc = "Expand Snippet" })

      -- Jump forward in snippet (use <C-k>)
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if ls.jumpable(1) then
          ls.jump(1)
        end
      end, { silent = true, desc = "Jump Forward in Snippet" })

      -- Jump backward in snippet (use <C-j>)
      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true, desc = "Jump Backward in Snippet" })

      vim.keymap.set({ "i", "s" }, "<C-E>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = "Change Snippet Choice" })

      -- Load your custom snippets
      local snippets_ok, my_snippets = pcall(require, "config.utils.snippets_util")
      if not snippets_ok then
        vim.notify("Error loading snippets", vim.log.levels.ERROR)
        return
      end

      -- Add snippets for PHP
      ls.add_snippets("php", my_snippets.php)
      ls.add_snippets("go", my_snippets.go)
    end,
  },
}
