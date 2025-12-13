return {
	{
		"piersolenski/telescope-import.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").load_extension("import")
		end,
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "folke/snacks.nvim" },
		},
		event = "LspAttach",
		opts = {},
		keys = {
			{
				"<leader>ca",
				function()
					-- [FIX] Truyền table rỗng vào nếu hàm yêu cầu tham số
					require("tiny-code-action").code_action({})
				end,
				mode = { "n", "x" },
				desc = "Code Action",
			},
		},
	},
}
