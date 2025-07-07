return {
  {
    "greggh/claude-code.nvim",
    cmd = "ClaudeCode",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      window = {
        position = "float",
        float = {
          width = "70%", -- Take up 90% of the editor width
          height = "70%", -- Take up 90% of the editor height
          row = "center", -- Center vertically
          col = "center", -- Center horizontally
          relative = "editor",
          border = "rounded", -- Use double border style
        },
      },
    },
  },
}
