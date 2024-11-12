return {
	{
		"folke/noice.nvim",
		opts = {
			presets = {
				bottom_search = false,
				lsp_doc_border = true,
			},
			lsp = {
				hover = {
					silent = true,
				},
			},
		},
	},
	-- {
	-- 	"rcarriga/nvim-notify",
	-- 	opts = {
	-- 		timeout = 2500,
	-- 		fps = 170,
	-- 		stages = "fade_in_slide_out",
	-- 	},
	-- },
}
