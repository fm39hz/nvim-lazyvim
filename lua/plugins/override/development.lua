return {
	{
		"Saghen/blink.cmp",
		opts = {
			keymap = {
				preset = "super-tab",
			},
			signature = { window = { border = "rounded" } },
			completion = {
				menu = { border = "rounded" },
				documentation = { window = { border = "rounded" } },
				trigger = {
					show_on_insert_on_trigger_character = false,
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				omnisharp = {
					enable_editor_config_support = true,
					settings = {
						EnableEditorConfigSupport = true,
					},
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				cs = {},
			},
			formatters = {
				csharpier = {
					command = "",
				},
			},
		},
	},
	{
		"mfussenegger/nvim-dap",
		opts = {
			adapters = {
				godot = {
					type = "server",
					host = "127.0.0.1",
					port = 6006,
				},
			},
			configurations = {
				cs = {
					{
						type = "godot",
						request = "launch",
						name = "Launch Scene",
						project = "${workspaceFolder}",
						launch_scene = true,
					},
				},
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		opts = {
			expand_lines = true,
			icons = { expanded = "", collapsed = "", circular = "" },
			layouts = {
				{
					elements = {
						{ id = "watches",     size = 0.24 },
						{ id = "scopes",      size = 0.24 },
						{ id = "breakpoints", size = 0.24 },
						{ id = "stacks",      size = 0.28 },
					},
					size = 0.23,
					position = "right",
				},
				{
					elements = {
						{ id = "repl",    size = 0.55 },
						{ id = "console", size = 0.45 },
					},
					size = 0.27,
					position = "bottom",
				},
			},
			floating = {
				max_height = 0.9,
				max_width = 0.5,
				border = "rounded",
			},
		},
	},
}
