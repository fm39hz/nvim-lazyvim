return {
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    opts = {
      use_trouble_qflist = true,
    },
    ft = {
      "typescript",
      "typescriptreact",
    },
  },
  {
    "Redoxahmii/json-to-types.nvim",
    cmd = { "ConvertJSONtoTS", "ConvertJSONtoTSBuffer" },
    build = "sh install.sh bun",
    ft = {
      "typescript",
      "typescriptreact",
    },
  },
  {
    "barrett-ruth/import-cost.nvim",
    build = "sh install.sh bun",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = {
      "typescript",
      "typescriptreact",
    },
  },
}
