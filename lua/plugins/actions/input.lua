return {
	{
		"keaising/im-select.nvim",
		event = "BufReadPost",
		opts = {
			default_command = "fcitx5-remote",
			default_im_select = "keyboard-us",
			set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
		},
	},
	{
		"rachartier/tiny-code-action.nvim",
		event = "BufReadPost",
		dependencies = {
			{ "folke/snacks.nvim" },
		},
		opts = {},
		keys = {
			{
				"<leader>ca",
				function()
					require("tiny-code-action").code_action({})
				end,
				mode = { "n", "x" },
				desc = "Code Action",
			},
		},
	},
}
