return {
	{
		"obsidian-nvim/obsidian.nvim",
		event = "BufReadPre " .. vim.fn.expand("~") .. "/Workspace/Notes/Obsidian/*/*.md",
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "samsara",
					path = "~/Workspace/Notes/Obsidian/ProjectSamsara",
				},
			},
			notes_subdir = "notes",
			daily_notes = {
				folder = "notes/dailies",
				date_format = "%Y-%m-%d",
				alias_format = "%B %-d, %Y",
				default_tags = { "daily-notes" },
				template = nil,
				workdays_only = true,
			},
			completion = {
				nvim_cmp = false,
				blink = true,
				min_chars = 2,
			},
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
					return "nsxiv -b " .. img
				end,
			},
		},
	},
}
