return {
	-- 1. Formatter
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				["javascript"] = { "biome", stop_after_first = true },
				["typescript"] = { "biome", stop_after_first = true },
				["javascriptreact"] = { "biome", stop_after_first = true },
				["typescriptreact"] = { "biome", stop_after_first = true },
			},
		},
	},

	-- 2. LSP (vtsls)
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				tsserver = { enabled = false },
				ts_ls = { enabled = false },
				vtsls = {
					settings = {
						complete_function_calls = true,
					},
				},
			},
		},
	},

	-- 3. Support tools
	{
		"dmmulroy/tsc.nvim",
		cmd = "TSC",
		opts = { use_trouble_qflist = true },
	},
	{
		"Redoxahmii/json-to-types.nvim",
		cmd = { "ConvertJSONtoTS", "ConvertJSONtoTSBuffer" },
		build = "sh install.sh bun",
	},
	{
		"barrett-ruth/import-cost.nvim",
		build = "sh install.sh bun",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	},
	{
		"dmmulroy/ts-error-translator.nvim",
		ft = { "typescript", "typescriptreact" },
	},
}
