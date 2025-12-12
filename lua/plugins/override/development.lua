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
