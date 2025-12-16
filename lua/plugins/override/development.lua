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
          show_in_snippet = false,
          show_on_insert_on_trigger_character = false,
        },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    -- Thêm keymap vào đây
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
    keys = {
      -- Dap Scope
      {
        "<leader>dS",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "Floating Scopes",
      },

      -- Dap Console
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
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
    },

    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
    end,
  },
}
