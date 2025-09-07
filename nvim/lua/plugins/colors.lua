return {
  {
  'ribru17/bamboo.nvim',
	name = "bamboo",
	config = function()
		require("bamboo").setup({
			styles = {
				transparency = false,
			},
		})
		vim.cmd("colorscheme bamboo")
	end
  }
}
