-- Helper function to find Godot project file and directory
local function find_godot_project()
	-- Create cache to avoid repeated lookups
	if not _G.godot_project_cache then
		_G.godot_project_cache = {}
	end

	-- Start with current working directory
	local current_dir = vim.fn.getcwd()

	-- Check cache first
	if _G.godot_project_cache[current_dir] then
		return _G.godot_project_cache[current_dir].file_path, _G.godot_project_cache[current_dir].dir_path
	end

	-- Function to check if a directory contains a project.godot file
	local function has_project_file(dir)
		local project_file = dir .. "/project.godot"
		local stat = vim.uv.fs_stat(project_file)
		if stat and stat.type == "file" then
			return project_file, dir
		else
			return nil, nil
		end
	end

	-- Check current directory first
	local project_file, project_dir = has_project_file(current_dir)
	if project_file then
		_G.godot_project_cache[current_dir] = { file_path = project_file, dir_path = project_dir }
		Snacks.notifier.notify("Found Godot project at: " .. project_file, vim.log.levels.INFO)
		return project_file, project_dir
	end

	-- Search in parent directories up to a reasonable limit
	local max_depth = 5
	local dir = current_dir

	for _ = 1, max_depth do
		-- Get parent directory
		local parent = vim.fn.fnamemodify(dir, ":h")

		-- Stop if we've reached the root
		if parent == dir then
			break
		end

		dir = parent

		-- Check if this directory has a project.godot file
		local project_file, project_dir = has_project_file(dir)
		if project_file then
			_G.godot_project_cache[current_dir] = { file_path = project_file, dir_path = project_dir }
			Snacks.notifier.notify("Found Godot project in parent directory: " .. project_file, vim.log.levels.INFO)
			return project_file, project_dir
		end
	end

	-- Search in immediate subdirectories (first level only)
	local handle = vim.uv.fs_scandir(current_dir)
	if handle then
		while true do
			local name, type = vim.uv.fs_scandir_next(handle)
			if not name then
				break
			end

			-- Only check directories
			if type == "directory" then
				local subdir = current_dir .. "/" .. name
				local project_file, project_dir = has_project_file(subdir)
				if project_file then
					_G.godot_project_cache[current_dir] = { file_path = project_file, dir_path = project_dir }
					Snacks.notifier.notify("Found Godot project in subdirectory: " .. project_file, vim.log.levels.INFO)
					return project_file, project_dir
				end
			end
		end
	end

	-- If still not found, ask the user
	local input_dir = vim.fn.input("Godot project directory: ", current_dir, "dir")

	-- Validate the input path
	if input_dir ~= "" then
		local project_file, project_dir = has_project_file(input_dir)
		if project_file then
			_G.godot_project_cache[current_dir] = { file_path = project_file, dir_path = project_dir }
			return project_file, project_dir
		end
	end

	Snacks.notifier.notify("No valid Godot project found. Using current directory.", vim.log.levels.WARN)
	return current_dir .. "/project.godot", current_dir
end

-- Get important environment variables for Godot
local function get_env_vars()
	return {
		-- Graphics-related variables
		DISPLAY = os.getenv("DISPLAY") or ":0",
		WAYLAND_DISPLAY = os.getenv("WAYLAND_DISPLAY"),
		XDG_SESSION_TYPE = os.getenv("XDG_SESSION_TYPE"),
		XAUTHORITY = os.getenv("XAUTHORITY"),

		-- User-related variables
		HOME = os.getenv("HOME"),
		USER = os.getenv("USER"),
		LOGNAME = os.getenv("LOGNAME"),

		-- Path-related variables
		PATH = os.getenv("PATH"),
		LD_LIBRARY_PATH = os.getenv("LD_LIBRARY_PATH"),

		-- Locale variables
		LANG = os.getenv("LANG") or "en_US.UTF-8",
		LC_ALL = os.getenv("LC_ALL"),

		-- XDG variables
		XDG_RUNTIME_DIR = os.getenv("XDG_RUNTIME_DIR"),
		XDG_DATA_HOME = os.getenv("XDG_DATA_HOME"),
		XDG_CONFIG_HOME = os.getenv("XDG_CONFIG_HOME"),

		-- Other potentially relevant variables
		DBUS_SESSION_BUS_ADDRESS = os.getenv("DBUS_SESSION_BUS_ADDRESS"),
	}
end
return {
	{
		"Saghen/blink.cmp",
		opts = {
			-- keymap = {
			-- 	preset = "super-tab",
			-- },
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
					cmd = {
						"OmniSharp",
						"-z",
						"--hostPID",
						tostring(vim.fn.getpid()),
						"DotNet:enablePackageRestore=false",
						"--encoding",
						"utf-8",
						"--languageserver",
					},
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
				coreclr = {
					type = "executable",
					command = vim.fn.exepath("netcoredbg") or "/home/fm39hz/.local/share/nvim/mason/bin/netcoredbg",
					args = {
						"--interpreter=vscode",
						"--",
						os.getenv("GODOT") or "/home/fm39hz/.config/godotenv/godot/bin/godot",
					},
				},
			},
			configurations = {
				cs = {
					{
						type = "coreclr",
						request = "launch",
						name = "Simple Editor Launch",
						cwd = function()
							local project_file, project_dir = find_godot_project()
							Snacks.notifier.notify("cwd " .. project_dir, "info")
							Snacks.notifier.notify("file " .. project_file, "info")
							return project_dir
						end,
						env = get_env_vars(),
						args = function()
							local project_file, project_dir = find_godot_project()
							Snacks.notifier.notify("cwd " .. project_dir, "info")
							return { " --editor " .. project_file }
						end,
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
