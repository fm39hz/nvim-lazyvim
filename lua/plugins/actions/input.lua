return {
  {
    "keaising/im-select.nvim",
    event = "BufReadPre",
    opts = {
      default_command = "fcitx5-remote",
      default_im_select = "keyboard-us",
      set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
    },
  },
}
