-- lua/plugins/language/csharp.lua

-- [HELPER] Hàm tìm project Godot (Giữ nguyên logic cache xịn của bạn)
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
    Snacks.notifier.notify("Found Godot project at: " .. project_file, vim.log.levels.INFO)
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

  -- Quét thư mục con cấp 1 (Logic của bạn)
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
  -- 1. [QUAN TRỌNG] Thêm lại Syntax Highlighting (Vì đã tắt lang.dotnet)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "c_sharp" })
      end
    end,
  },

  -- 2. Dùng Roslyn (Xịn hơn Omnisharp cho .NET 9)
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    opts = {
      -- Roslyn tự handle việc tìm solution
    },
    dependencies = { "mason-org/mason.nvim" },
  },

  -- 3. Formatter (Cấu hình đúng command)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
      formatters = {
        csharpier = {
          command = "dotnet-csharpier", -- Sửa lỗi command rỗng
        },
      },
    },
  },

  -- 4. Debugger (DAP) - Logic Godot chuẩn chỉ
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      -- Tìm Godot executable (Ưu tiên biến môi trường)
      local godot_executable = os.getenv("GODOT") or "godot"

      -- A. Adapter: Chỉ thuần túy là netcoredbg
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.exepath("netcoredbg"),
        args = { "--interpreter=vscode" },
      }

      -- B. Configuration: Định nghĩa cách chạy
      dap.configurations.cs = {
        -- CONFIG 1: Chơi Game trực tiếp (Nhanh & Ổn định)
        {
          type = "coreclr",
          name = "Godot: Play Project",
          request = "launch",
          program = godot_executable, -- Netcoredbg sẽ gọi Godot
          cwd = function()
            local _, dir = find_godot_project()
            return dir or vim.fn.getcwd()
          end,
          args = { "--path", ".", "--verbose" }, -- Chạy project tại thư mục tìm được
          env = { GODOT4_MONO = "1" },
        },

        -- CONFIG 2: Chạy Backend Grimoire (DLL)
        {
          type = "coreclr",
          name = "NetCore: Launch DLL",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
          end,
          cwd = "${workspaceFolder}",
        },

        -- CONFIG 3: Attach (Cho trường hợp mở game bên ngoài)
        {
          type = "coreclr",
          name = "Attach",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }
    end,
  },

  -- 5. Đảm bảo tool được cài
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "netcoredbg", "csharpier" })
    end,
  },
}
