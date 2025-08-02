return {
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
	{
		"pmizio/typescript-tools.nvim",
		event = { "BufReadPre", "BufNewFile", "VimEnter" },
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		cond = function()
			-- Function to check if package.json exists in project root
			local function has_package_json()
				local util = require("lspconfig.util")
				local root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(
					vim.fn.expand("%:p") ~= "" and vim.fn.expand("%:p") or vim.fn.getcwd()
				)
				return root_dir and vim.fn.filereadable(root_dir .. "/package.json") == 1
			end
			return has_package_json()
		end,
		opts = {},
	},
}
