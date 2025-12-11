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
		"seblyng/roslyn.nvim",
		ft = "cs",
		dependencies = { "mason-org/mason.nvim" },
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		opts = {},
	},

	-- 3. Formatter
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = { cs = { "csharpier" } },
			formatters = { csharpier = { command = "dotnet-csharpier" } },
		},
	},

	-- 4. Debugger (DAP) - Logic Godot Adapter
	{
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			local godot_executable = os.getenv("GODOT") or "godot"
			local netcoredbg_path = vim.fn.exepath("netcoredbg")

			dap.adapters.coreclr = {
				type = "executable",
				command = netcoredbg_path,
				args = { "--interpreter=vscode" },
			}

			dap.adapters.godot = function(cb, config)
				local _, project_dir = find_godot_project()
				project_dir = project_dir or vim.fn.getcwd()
				cb({
					type = "executable",
					command = netcoredbg_path,
					args = { "--interpreter=vscode", "--", godot_executable, "--path", project_dir, "--verbose" },
				})
			end

			dap.configurations.cs = {
				{
					type = "godot",
					name = "Godot: Launch Game",
					request = "launch",
					program = "",
					cwd = "${workspaceFolder}",
				},
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

	-- 5. Mason Tools (Must install roslyn)
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			}
			opts.ensure_installed = opts.ensure_installed or {}
			-- Chỉ cài những thứ cần thiết
			vim.list_extend(opts.ensure_installed, { "netcoredbg", "csharpier", "roslyn" })
		end,
	},
}
