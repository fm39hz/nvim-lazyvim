return {
	{
		"7sedam7/perec.nvim",
		ft = "markdown",
		opts = {
			cwd = vim.fn.getcwd(),
		},
	},
	{
		"jmbuhr/otter.nvim",
		ft = "markdown",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"javiorfo/nvim-soil",
		dependencies = { "javiorfo/nvim-nyctophilia" },
		lazy = true,
		ft = "plantuml",
		opts = {
			image = {
				darkmode = false,
				format = "png",
				execute_to_open = function(img)
					local modified_img = img:gsub("%.g%.png", ".png")
					Snacks.win({
						file = modified_img,
						border = "rounded",
						width = 0.7,
						height = 0.7,
					})
					Snacks.notifier.hide()
				end,
			},
		},
	},
}
