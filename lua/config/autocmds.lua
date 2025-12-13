-- Autocmds are automatically loaded on the VeryLazy event

-- 1. Tự động format và sửa lỗi import khi lưu file (Dùng Native LSP/VTSLS)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buffer = args.buf

    -- [FIX 1] Check nil: client có thể không tồn tại nếu LSP crash hoặc chưa load xong
    if not client then
      return
    end

    -- Chỉ tạo autocmd format nếu client hỗ trợ (tránh lặp)
    if not client.server_capabilities.documentFormattingProvider then
      return
    end

    local augroup = vim.api.nvim_create_augroup("LspFormatting_" .. buffer, { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = buffer,
      callback = function()
        -- Format file
        vim.lsp.buf.format({ timeout = 2000, async = false })

        -- Logic riêng cho TypeScript/Javascript (Dùng vtsls nếu có)
        local filetype = vim.bo[buffer].filetype
        if vim.tbl_contains({ "typescript", "typescriptreact", "javascript", "javascriptreact" }, filetype) then
          -- [FIX 2] Check nil lần nữa cho chắc (dù ở trên đã check nhưng trong callback có thể khác)
          if client and client.name == "vtsls" then
            -- Organize Imports
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.organizeImports" },
                diagnostics = {}, -- [FIX 3] Thêm field diagnostics (bắt buộc theo type definition)
              },
            })
            -- Fix All (bao gồm add missing imports)
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                -- [FIX 4] Disable warning type mismatch vì "source.fixAll.ts" là chuỗi hợp lệ của VTSLS nhưng chưa có trong definition chuẩn của Neovim
                ---@diagnostic disable-next-line: assign-type-mismatch
                only = { "source.fixAll.ts" },
                diagnostics = {}, -- [FIX 3] Thêm field diagnostics
              },
            })
          end
        end
      end,
    })
  end,
})

-- 2. Clean Register (Wipe Alpha)
vim.api.nvim_create_autocmd("User", {
  pattern = "BufWritePre",
  callback = function()
    local chars = "abcdefghijklmnopqrstuvwxyz"
    for i = 1, #chars do
      local char = chars:sub(i, i)
      vim.fn.setreg(char, "")
    end
  end,
})

-- 3. Fix tên cửa sổ cho Tmux
vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave" }, {
  callback = function()
    if vim.env.TMUX_PLUGIN_MANAGER_PATH then
      -- [FIX 5] vim.uv.spawn yêu cầu 3 tham số: cmd, options, on_exit callback
      vim.uv.spawn(
        vim.env.TMUX_PLUGIN_MANAGER_PATH .. "/tmux-window-name/scripts/rename_session_windows.py",
        ---@diagnostic disable-next-line: missing-fields
        { args = {} }, -- Thêm args rỗng để thỏa mãn type check
        function() end -- Thêm callback rỗng
      )
    end
  end,
})

-- 4. Ẩn Copilot khi menu Blink hiện lên
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpCompletionMenuOpen",
  callback = function()
    if package.loaded["copilot.suggestion"] then
      require("copilot.suggestion").dismiss()
      vim.b.copilot_suggestion_hidden = true
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpCompletionMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
