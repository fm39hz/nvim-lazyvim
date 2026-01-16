return {
	-- 1. Syntax Highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "c_sharp" })
			end
		end,
	},

	-- 2. Roslyn LSP
	{
		"seblyng/roslyn.nvim",
		event = "LspAttach",
		ft = "cs",
		dependencies = { "mason-org/mason.nvim", "j-hui/fidget.nvim" },
		opts = {},
	},

	-- 3. Formatter
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				cs = { "dotnet_format" },
			},
			formatters = {
				dotnet_format = {
					command = "dotnet format",
					args = { "--include", "$FILENAME", "--verbosity", "quiet" },
				},
			},
		},
	},

	-- 4. Debugger (DAP)
	{
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			local netcoredbg_path = vim.fn.exepath("netcoredbg")

			dap.adapters.coreclr = {
				type = "executable",
				command = netcoredbg_path,
				args = { "--interpreter=vscode" },
			}

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "NetCore: Launch DLL",
					request = "launch",
					program = function()
						return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
				{
					type = "coreclr",
					name = "Attach (Pick Process)",
					request = "attach",
					processId = require("dap.utils").pick_process,
				},
			}
		end,
	},

	-- 5. Mason dependencies
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			}
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "netcoredbg", "csharpier", "roslyn" })
		end,
	},

	-- 6. Godot Tools
	{
		-- dir = "/home/fm39hz/Workspace/Personal/Rice/nvim-dap-godot-mono",
		-- name = "dap-godot-mono",
		"fm39hz/nvim-dap-godot-mono",
		dependencies = {
			"stevearc/overseer.nvim",
		},
		ft = "cs",
		opts = {},
	},
}
