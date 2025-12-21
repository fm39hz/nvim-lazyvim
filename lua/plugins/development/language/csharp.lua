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
    opts = {},
    init = function()
      vim.api.nvim_create_user_command("CSFixUsings", function()
        local bufnr = vim.api.nvim_get_current_buf()

        local clients = vim.lsp.get_clients({ name = "roslyn" })
        if not clients or vim.tbl_isempty(clients) then
          vim.notify("Couldn't find client", vim.log.levels.ERROR, { title = "Roslyn" })
          return
        end

        local client = clients[1]
        local action = {
          kind = "quickfix",
          data = {
            CustomTags = { "RemoveUnnecessaryImports" },
            TextDocument = { uri = vim.uri_from_bufnr(bufnr) },
            CodeActionPath = { "Remove unnecessary usings" },
            Range = {
              ["start"] = { line = 0, character = 0 },
              ["end"] = { line = 0, character = 0 },
            },
            UniqueIdentifier = "Remove unnecessary usings",
          },
        }

        client:request("codeAction/resolve", action, function(err, resolved_action)
          if err then
            vim.notify("Fix using directives failed", vim.log.levels.ERROR, { title = "Roslyn" })
            return
          end
          vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
        end)
      end, { desc = "Remove unnecessary using directives" })
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
            vim.api.nvim_create_autocmd("InsertCharPre", {
              desc = "Roslyn: Trigger an auto insert on '/'.",
              buffer = bufnr,
              callback = function()
                local char = vim.v.char

                if char ~= "/" then
                  return
                end

                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                row, col = row - 1, col + 1
                local uri = vim.uri_from_bufnr(bufnr)

                local params = {
                  _vs_textDocument = { uri = uri },
                  _vs_position = { line = row, character = col },
                  _vs_ch = char,
                  _vs_options = {
                    tabSize = vim.bo[bufnr].tabstop,
                    insertSpaces = vim.bo[bufnr].expandtab,
                  },
                }

                -- NOTE: We should send textDocument/_vs_onAutoInsert request only after
                -- buffer has changed.
                vim.defer_fn(function()
                  client:request(
                  ---@diagnostic disable-next-line: param-type-mismatch
                    "textDocument/_vs_onAutoInsert",
                    params,
                    function(err, result, _)
                      if err or not result then
                        return
                      end

                      vim.snippet.expand(result._vs_textEdit.newText)
                    end,
                    bufnr
                  )
                end, 1)
              end,
            })
          end
        end,
      })
    end,
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
