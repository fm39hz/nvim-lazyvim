return {
  {
    "iabdelkareem/csharp.nvim",
    ft = "cs",
    keys = {
      {
        "<F5>",
        function()
          require("csharp").debug_project()
        end,
        { desc = "C# debug project", noremap = true, nowait = true },
      },
    },
    dependencies = {
      "mfussenegger/nvim-dap",
      "Tastyep/structlog.nvim",
    },
    config = function()
      require("mason").setup()
      require("csharp").setup()
    end,
  },
}
