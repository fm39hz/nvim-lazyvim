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
		ft = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
		config = function(_, opts)
			require("typescript-tools").setup(opts)

			-- Add the autocmd here to ensure plugin is loaded
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
				callback = function()
					vim.cmd("TSToolsFixAll")
					vim.cmd("TSToolsOrganizeImports")
					vim.cmd("TSToolsAddMissingImports")
					vim.cmd(":w")
				end,
				desc = "Run TypeScript tools after save",
			})
		end,
	},
}
