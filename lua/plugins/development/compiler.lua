return {
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = {
      "stevearc/overseer.nvim",
    },
    opts = {},
    keys = {
      { "<F6>",   "<cmd>CompilerOpen<cr>",          desc = "Open compiler" },
      { "<S-F6>", "<cmd>CompilerRedo<cr>",          desc = "Compiler redo" },
      { "<S-F7>", "<cmd>CompilerToggleResults<cr>", desc = "Compiler results" },
    },
  },
  {
    "stevearc/overseer.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo", "OverseerRun" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
}
