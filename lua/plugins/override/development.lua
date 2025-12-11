return {
  {
    "Saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
      },
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

  -- 1. Tinh chỉnh giao diện DAP UI (Chuyển sang Float & Tắt Auto-open)
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- Định nghĩa phím tắt MỚI cho Floating Window
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

      -- [MỚI] Các phím tắt Zen Mode (Floating)
      {
        "<leader>dc",
        function()
          require("dapui").float_element("console", { enter = true, width = 100, height = 20 })
        end,
        desc = "Debug: Float Console",
      },
      {
        "<leader>ds",
        function()
          require("dapui").float_element("scopes", { enter = true, width = 80, height = 20 })
        end,
        desc = "Debug: Float Scopes",
      },
      {
        "<leader>dr",
        function()
          require("dapui").float_element("repl", { enter = true })
        end,
        desc = "Debug: Float REPL",
      },
      {
        "<leader>dk",
        function()
          require("dapui").float_element("stacks", { enter = true })
        end,
        desc = "Debug: Float Stack",
      },
    },
    opts = {
      -- Cấu hình hiển thị cửa sổ nổi cho đẹp
      floating = {
        max_height = 0.9,
        max_width = 0.8,
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      -- Giữ layout split mặc định phòng khi bạn bấm <leader>du để xem tổng thể
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = { "repl", "console" },
          size = 10,
          position = "bottom",
        },
      },
    },
    -- [QUAN TRỌNG] Ghi đè hàm config để XÓA BỎ auto-open listeners
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)

      -- Lưu ý: Tôi KHÔNG thêm dòng dap.listeners... như config gốc.
      -- Điều này có nghĩa là UI sẽ KHÔNG bao giờ tự bật lên trừ khi bạn bấm phím.
    end,
  },

  -- 2. Tinh chỉnh Virtual Text (Giá trị biến hiện ngay dòng code)
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      -- Hiện giá trị dưới dạng comment (vd: // x = 5) cho đỡ rối mắt
      commented = true,
      -- Chỉ hiện biến đã thay đổi (giảm nhiễu)
      only_first_definition = false,
      all_references = true,
      display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == "inline" then
          return " = " .. variable.value
        else
          return variable.name .. " = " .. variable.value
        end
      end,
    },
  },
}
