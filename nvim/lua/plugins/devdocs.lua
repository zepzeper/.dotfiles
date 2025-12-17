return {
	"luckasRanarison/nvim-devdocs",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		dir_path = vim.fn.stdpath("data") .. "/devdocs",
		telescope = {},
		float_win = {
			relative = "editor",
			height = 50,
			width = 100,
			border = "single",
		},
		wrap = false,
		previewer_cmd = nil,
		cmd_args = {},
		cmd_ignore = {},
		picker_cmd = false,
		picker_cmd_args = {},
		mappings = {
			open_in_browser = "",
		},
		ensure_installed = {
            -- "laravel~11",
            -- "php",
			"go",
			"typescript",
			"lua~5.1",
		},
		after_open = function(bufnr)
			-- Mark the buffer as a DevDocs buffer
			vim.b[bufnr].is_devdocs = true
		end,
	},
	config = function(_, opts)
		require("nvim-devdocs").setup(opts)

		-- Helper function to check if a buffer is a DevDocs buffer
		local function is_devdocs_buffer(buf)
			local bufname = vim.api.nvim_buf_get_name(buf)
			-- Check buffer variable or buffer name pattern
			return vim.b[buf].is_devdocs == true or bufname:match("devdocs://")
		end

		-- Helper function to find DevDocs window and buffer
		local function find_devdocs_window()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				if is_devdocs_buffer(buf) then
					return win, buf
				end
			end
			return nil, nil
		end

		-- Helper function to find any DevDocs buffer (even if not visible)
		local function find_devdocs_buffer()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) and is_devdocs_buffer(buf) then
					return buf
				end
			end
			return nil
		end

		-- Toggle function (for hiding/showing existing window)
		local function toggle_devdocs_window()
			local win, buf = find_devdocs_window()
			
			-- If window is open, close it
			if win then
				vim.api.nvim_win_close(win, false)
				return
			end

			-- If buffer exists but window is closed, reopen it
			buf = find_devdocs_buffer()
			if buf then
				local width = opts.float_win.width or 100
				local height = opts.float_win.height or 50
				
				vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					width = width,
					height = height,
					col = math.floor((vim.o.columns - width) / 2),
					row = math.floor((vim.o.lines - height) / 2),
					border = opts.float_win.border or "single",
					style = "minimal",
				})
			else
				vim.notify("No DevDocs buffer to toggle. Open DevDocs first with <leader>d", vim.log.levels.WARN)
			end
		end

		-- Open DevDocs function
		local function open_devdocs(ft)
			if ft and ft ~= "" then
				vim.cmd("DevdocsOpenFloat " .. ft)
			else
				vim.cmd("DevdocsOpenFloat")
			end
		end

		-- Set up keymaps
		vim.keymap.set("n", "<leader>d", function()
			local ft = vim.bo.filetype
			open_devdocs(ft)
		end, { desc = "Open DevDocs (current filetype)" })

		vim.keymap.set("n", "<leader>D", function()
			open_devdocs()
		end, { desc = "Open DevDocs (all docs)" })

		vim.keymap.set("n", "<C-t>", toggle_devdocs_window, { desc = "Toggle DevDocs window" })
	end,
}

