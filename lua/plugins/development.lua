require("dap.ext.vscode").load_launchjs()
return {
	-- Overall
	{
		"Zeioth/compiler.nvim",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		dependencies = {
			"stevearc/overseer.nvim",
		},
		opts = {},
	},
	{
		"stevearc/overseer.nvim",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo", "OverseerRun" },
		opts = {
			task_list = {
				direction = "bottom",
				min_height = 25,
				max_height = 25,
				default_detail = 1,
			},
		},
	},
	{
		"zeioth/garbage-day.nvim",
		event = "LspAttach",
		dependencies = "neovim/nvim-lspconfig",
		opts = {},
	},
	{
		"piersolenski/telescope-import.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").load_extension("import")
		end,
	},
	-- TS / JS
	{
		"dmmulroy/tsc.nvim",
		cmd = "TSC",
		opts = {
			use_trouble_qflist = true,
		},
		ft = {
			"typescript",
			"typescriptreact",
		},
	},
	{
		"Redoxahmii/json-to-types.nvim",
		cmd = { "ConvertJSONtoTS", "ConvertJSONtoTSBuffer" },
		build = "sh install.sh bun",
		ft = {
			"typescript",
			"typescriptreact",
		},
	},
	{
		"barrett-ruth/import-cost.nvim",
		build = "sh install.sh bun",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
	},
	{
		"dmmulroy/ts-error-translator.nvim",
		ft = {
			"typescript",
			"typescriptreact",
		},
	},
	-- LSP config
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
}
