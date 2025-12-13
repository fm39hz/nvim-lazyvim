return {
  -- 1. Formatter
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

  -- 2. LSP (vtsls)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Tắt server thừa (Quan trọng để tránh xung đột)
        tsserver = { enabled = false },
        ts_ls = { enabled = false },
        vtsls = {
          settings = {
            complete_function_calls = true,
          },
          keys = {
            -- reference
            { "<leader>co", LazyVim.lsp.action["source.organizeImports"], desc = "Organize Imports" },
          },
        },
      },
    },
  },

  -- 3. Support tools
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    opts = { use_trouble_qflist = true },
    ft = { "typescript", "typescriptreact" },
  },
  {
    "Redoxahmii/json-to-types.nvim",
    cmd = { "ConvertJSONtoTS", "ConvertJSONtoTSBuffer" },
    build = "sh install.sh bun",
    ft = { "typescript", "typescriptreact" },
  },
  {
    "barrett-ruth/import-cost.nvim",
    build = "sh install.sh bun",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact" },
  },
}
