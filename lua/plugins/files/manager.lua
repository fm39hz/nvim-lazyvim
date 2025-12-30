return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    cmd = { "Yazi" },
    keys = {
      {
        "<leader>fm",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>fM",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>fy",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      floating_window_scaling_factor = 0.75,
      yazi_floating_window_winblend = 0,
      keymaps = {
        -- open_file_in_vertical_split = "J",
        -- open_file_in_horizontal_split = "K",
        -- open_file_in_tab = "L",
      },
    },
  },
}
