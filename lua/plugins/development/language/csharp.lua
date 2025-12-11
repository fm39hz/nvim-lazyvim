-- [HELPER]
local function find_godot_project()
	if not _G.godot_project_cache then
		_G.godot_project_cache = {}
	end
	local current_dir = vim.fn.getcwd()
	if _G.godot_project_cache[current_dir] then
		return _G.godot_project_cache[current_dir].file_path, _G.godot_project_cache[current_dir].dir_path
	end
	local function has_project_file(dir)
		local project_file = dir .. "/project.godot"
		local stat = vim.uv.fs_stat(project_file)
		if stat and stat.type == "file" then
			return project_file, dir
		else
			return nil, nil
		end
	end
	local project_file, project_dir = has_project_file(current_dir)
	if project_file then
		_G.godot_project_cache[current_dir] = { file_path = project_file, dir_path = project_dir }
		return project_file, project_dir
	end
	local max_depth = 5
	local dir = current_dir
	for _ = 1, max_depth do
		local parent = vim.fn.fnamemodify(dir, ":h")
		if parent == dir then
			break
		end
		dir = parent
		local p_file, p_dir = has_project_file(dir)
		if p_file then
			_G.godot_project_cache[current_dir] = { file_path = p_file, dir_path = p_dir }
			return p_file, p_dir
		end
	end
	local handle = vim.uv.fs_scandir(current_dir)
	if handle then
		while true do
			local name, type = vim.uv.fs_scandir_next(handle)
			if not name then
				break
			end
			if type == "directory" then
				local subdir = current_dir .. "/" .. name
				local p_file, p_dir = has_project_file(subdir)
				if p_file then
					_G.godot_project_cache[current_dir] = { file_path = p_file, dir_path = p_dir }
					return p_file, p_dir
				end
			end
		end
	end
	return nil, nil
end

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
		"seblj/roslyn.nvim",
		ft = "cs",
		opts = {},
		dependencies = { "mason-org/mason.nvim" },
	},

	-- 3. Formatter
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { cs = { "csharpier" } },
			formatters = { csharpier = { command = "dotnet-csharpier" } },
		},
	},

	-- 4. Debugger (DAP)
	{
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			local godot_executable = os.getenv("GODOT") or "godot"
			local netcoredbg_path = vim.fn.exepath("netcoredbg")

			-- ADAPTER A: "coreclr" (Standard)
			-- Used for standard .NET debugging (e.g., backend services)
			dap.adapters.coreclr = {
				type = "executable",
				command = netcoredbg_path,
				args = { "--interpreter=vscode" },
			}

			-- ADAPTER B: "godot" (Custom Wrapper)
			-- Used for debugging Godot projects
			-- Logic: netcoredbg runs Godot as a child process to capture its output
			dap.adapters.godot = function(cb, config)
				local _, project_dir = find_godot_project()
				project_dir = project_dir or vim.fn.getcwd()

				cb({
					type = "executable",
					command = netcoredbg_path,
					-- Invoke Godot with the project path and verbose flag
					args = {
						"--interpreter=vscode",
						"--",
						godot_executable,
						"--path",
						project_dir,
						"--verbose",
					},
				})
			end

			-- CONFIGURATIONS
			dap.configurations.cs = {
				-- CONFIG 1: Godot (Use adapter 'godot')
				{
					type = "godot", -- Points to adapter B
					name = "Godot: Launch Game",
					request = "launch", -- Use LAUNCH to let netcoredbg capture output
					program = "", -- Leave empty because the adapter handles the path
					cwd = "${workspaceFolder}",
				},

				-- CONFIG 2: Backend Grimoire (Use adapter 'coreclr')
				{
					type = "coreclr", -- Points to adapter A
					name = "NetCore: Launch DLL",
					request = "launch",
					program = function()
						return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
					end,
					cwd = "${workspaceFolder}",
				},

				-- CONFIG 3: Attach (Fallback)
				{
					type = "coreclr",
					name = "Attach (Pick Process)",
					request = "attach",
					processId = require("dap.utils").pick_process,
				},
			}
		end,
	},

	-- 5. Mason Tools
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "netcoredbg", "csharpier" })
		end,
	},
}
