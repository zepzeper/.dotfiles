return {
  { "L3MON4D3/LuaSnip", keys = {} },
  {
   "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      'Exafunction/codeium.nvim',
    },
    version = "*",
    config = function()
      vim.cmd('highlight Pmenu guibg=none')
      vim.cmd('highlight PmenuExtra guibg=none')
      vim.cmd('highlight FloatBorder guibg=none')
      vim.cmd('highlight NormalFloat guibg=none')

      require("blink.cmp").setup({
        snippets = { preset = "luasnip" },
        signature = { enabled = true },
        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = "normal",
        },
        sources = {
          default = { "laravel", "lazydev", "lsp", "path", "snippets", "buffer", "codeium"},
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100,
            },
            codeium = { name = 'Codeium', module = 'codeium.blink', async = true },
            laravel = {
              name = "Laravel",
              module = "laravel.blink_source",
              enabled = function()
                return vim.bo.filetype == 'php' or vim.bo.filetype == 'blade'
              end,
              score_offset = 1000, -- Highest priority
              min_keyword_length = 1,
            },
            cmdline = {
              min_keyword_length = 2,
            },
          },
        },
        keymap = {
          ["<C-f>"] = {},
        },
        cmdline = {
          enabled = false,
          completion = { menu = { auto_show = true } },
          keymap = {
            ["<CR>"] = { "accept_and_enter", "fallback" },
          },
        },
        completion = {
          menu = {
            border = nil,  -- Change from "rounded"
            scrollbar = false,  -- Change from true
            scrolloff = 1,
            draw = {
              columns = {
                { "kind_icon" },
                { "label", "label_description", gap = 1 },
                { "kind" },
                { "source_name" },
              },
            },
          },
          documentation = {
            window = {
              border = nil,  -- Change from "rounded"
              scrollbar = false,  -- Change from true
              winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
            },
            auto_show = true,
            auto_show_delay_ms = 0,
          },
        }
      })

      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
