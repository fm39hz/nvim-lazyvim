return {
  -- LSP configuration for TypeScript/JavaScript (vtsls)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "prettier", stop_after_first = true },
        ["typescript"] = { "prettier", stop_after_first = true },
        ["javascriptreact"] = { "prettier", stop_after_first = true },
        ["typescriptreact"] = { "prettier", stop_after_first = true },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              preferences = {
                includeCompletionsForModuleExports = true,
                includeCompletionsForImportStatements = true,
                importModuleSpecifier = "project-relative",
              },
            },
          },
        },
      },
    },
  },
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
  {
    "pmizio/typescript-tools.nvim",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
}
