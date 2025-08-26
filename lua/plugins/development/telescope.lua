return {
  {
    "piersolenski/telescope-import.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("import")
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      {
        "folke/snacks.nvim",
        opts = {
          terminal = {},
        },
      },
    },
    event = "LspAttach",
    opts = {},
  },
}
