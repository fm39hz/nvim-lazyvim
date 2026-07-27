return {
	{
		"opdavies/toggle-checkbox.nvim",
		ft = "markdown",
		keys = {
			{
				"<leader>ct",
				function()
					require("toggle-checkbox").toggle()
				end,
				desc = "Toggle Checkbox",
			},
		},
	},
	{
		"yujinyuz/gitpad.nvim",
		opts = {
			title = "Note",
			border = "rounded",
			dir = "~/Workspace/Notes/",
		},
		keys = {
			{
				"<leader>pb",
				function()
					require("gitpad").toggle_gitpad_branch()
				end,
				desc = "Toggle Gitpad branch",
			},
			{
				"<leader>pd",
				function()
					local date_filename = "daily-" .. os.date("%Y-%m-%d.md")
					require("gitpad").toggle_gitpad({ filename = date_filename })
				end,
				desc = "Toggle Gitpad Daily notes",
			},
			{
				"<leader>pf",
				function()
					local filename = vim.fn.expand("%:p")
					if filename == "" then
						vim.notify("empty bufname")
						return
					end
					filename = vim.fn.pathshorten(filename, 2) .. ".md"
					require("gitpad").toggle_gitpad({ filename = filename })
				end,
				desc = "Toggle Gitpad per file notes",
			},
		},
	},
}
