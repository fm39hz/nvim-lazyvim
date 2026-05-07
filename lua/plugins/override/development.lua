return {
	{
		"Saghen/blink.cmp",
		opts = {
			signature = { window = { border = "rounded" } },
			completion = {
				menu = { border = "rounded" },
				documentation = { window = { border = "rounded" }, auto_show_delay_ms = 500 },
				trigger = {
					show_in_snippet = false,
					show_on_insert_on_trigger_character = false,
				},
				list = {
					selection = {
						preselect = false,
						auto_insert = true,
					},
				},
			},
			keymap = {
				preset = "super-tab",
			},
		},
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"lewis6991/async.nvim",
		},
		keys = {
			{
				"<leader>rs",
				function()
					require("refactoring").select_refactor()
				end,
				mode = { "n", "x" },
				desc = "Select Refactor",
			},

			{
				"<leader>re",
				function()
					require("refactoring").extract_func()
				end,
				mode = "x",
				desc = "Extract Function",
			},
			{
				"<leader>rf",
				function()
					require("refactoring").extract_func_to_file()
				end,
				mode = "x",
				desc = "Extract Function to File",
			},
			{
				"<leader>rv",
				function()
					require("refactoring").extract_var()
				end,
				mode = "x",
				desc = "Extract Variable",
			},
			{
				"<leader>ri",
				function()
					require("refactoring").inline_var()
				end,
				mode = { "n", "x" },
				desc = "Inline Variable",
			},
			{
				"<leader>rI",
				function()
					require("refactoring").inline_func()
				end,
				mode = "n",
				desc = "Inline Function",
			},

			{
				"<leader>pv",
				function()
					require("refactoring").debug.print_var()
				end,
				mode = { "n", "x" },
				desc = "Debug Print Var",
			},
			{
				"<leader>pp",
				function()
					require("refactoring").debug.print_loc()
				end,
				mode = "n",
				desc = "Debug Print Location",
			},
			{
				"<leader>pc",
				function()
					require("refactoring").debug.cleanup({})
				end,
				mode = "n",
				desc = "Debug Cleanup",
			},
		},
	},
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"K",
				function()
					local dap = require("dap")
					if dap.session() then
						require("dap.ui.widgets").hover()
					else
						vim.lsp.buf.hover()
					end
				end,
				desc = "Smart Hover (DAP/LSP)",
				mode = { "n", "v" },
			},
		},
	},

	{
		"rcarriga/nvim-dap-ui",
		-- 1. Giữ keymap để Lazy-load
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "Eval",
				mode = { "n", "x" },
			},
			{
				"<leader>dS",
				function()
					require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)
				end,
				desc = "Floating Scopes",
			},
			{
				"<leader>dC",
				function()
					require("dapui").float_element("console", { enter = true })
				end,
				desc = "Floating Console",
			},
		},
		opts = {
			controls = { enabled = false },
			icons = { expanded = "▾", collapsed = "▸", circular = "" },
			floating = {
				border = "rounded",
				mappings = { close = { "q", "<Esc>" } },
			},
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.60 },
						{ id = "stacks", size = 0.40 },
					},
					size = 35,
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size = 10,
					position = "bottom",
				},
			},
		},
		-- 2. Override hoàn toàn hàm config của LazyVim để CHẶN tự động mở UI
		config = function(_, opts)
			local dapui = require("dapui")
			dapui.setup(opts)

			-- Ở đây chúng ta KHÔNG định nghĩa dap.listeners.after.event_initialized
			-- Điều này chặn việc tự động nhảy UI ra khi bạn bắt đầu debug file C#

			-- Nếu bạn muốn tự động ĐÓNG khi kết thúc (nhưng không tự mở), hãy dùng:
			local dap = require("dap")
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},
}
