local get_intelephense_license = function ()
    local f = assert(io.open(os.getenv("HOME") .. "/intelephense/licence.txt", "rb"))
    local content = f:read("*a")
    f:close()
    return string.gsub(content, "%s+", "")
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local on_attach = function(client, bufnr)
        -- This is where we define the keymaps that will be set for every buffer with an LSP
        local keymap = vim.keymap
        local opts = { buffer = bufnr, silent = true }

        -- Your favorite Telescope-based keymaps
        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>E", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)
      end

      -- Setup Mason to manage our LSP server installations
      require('mason').setup()

      -- Define the list of servers we want
      local servers = {
        lua_ls = {},
        cssls = {},
        html = {},
        bashls = {},
        intelephense = {
          filetypes = { "php" },
          root_dir = require("lspconfig").util.root_pattern("composer.json", ".git"),
          settings = {
            intelephense = {
                --licenceKey = "00YNPEL2NKC5IE5"
                licenceKey = get_intelephense_license(),
            },
          },
        },
      }

      -- Loop through and configure each server
      for name, opts in pairs(servers) do
        require('lspconfig')[name].setup {
          on_attach = on_attach,
          settings = opts.settings,
        }
      end

      -- Modern way to configure diagnostic signs
      vim.diagnostic.config({
        signs = { text = { [vim.diagnostic.severity.ERROR] = '', [vim.diagnostic.severity.WARN] = '', [vim.diagnostic.severity.INFO] = '', [vim.diagnostic.severity.HINT] = '' } },
        underline = true, virtual_text = false, update_in_insert = false, severity_sort = true,
      })

      -- Custom command to trigger workspace indexing
      vim.api.nvim_create_user_command(
        'LspIndexWorkspace',
        function()
          -- Use the modern, correct API for sending custom requests
          for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            if client.name == 'intelephense' then
              client.request('workspace/executeCommand', { command = 'intelephense.index.workspace' }, function() print('Intelephense indexing triggered.') end)
            end
          end
        end,
        { desc = 'Trigger workspace indexing for Intelephense' }
      )
    end,
  },
}
