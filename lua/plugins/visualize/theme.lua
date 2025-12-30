---@diagnostic disable: missing-fields
return {
	{
		"neanias/everforest-nvim",
		config = function()
			require("everforest").setup({
				background = "medium",
				italics = true,
				ui_contrast = "high",
				diagnostic_text_highlight = true,
			})
		end,
	},
	{
		"aileot/ex-colors.nvim",
		lazy = true,
		cmd = "ExColors",
		opts = {},
	},
}
