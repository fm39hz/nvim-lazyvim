-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = args.buf,
			callback = function()
				vim.lsp.buf.format({ timeout = 1000, async = false })
				if vim.bo[0].filetype == "cs" then
					require("csharp").fix_usings()
				end
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "BufWritePre",
	callback = function()
		local chars = "abcdefghijklmnopqrstuvwxyz"
		---@type string[]
		local reg_chars = {}
		local _ = chars:gsub(".", function(v)
			table.insert(reg_chars, v)
		end)
		for _, v in pairs(reg_chars) do
			vim.fn.setreg(v, "")
		end
		vim.cmd.wshada({ bang = true })
	end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave" }, {
	callback = function()
		if vim.env.TMUX_PLUGIN_MANAGER_PATH then
			vim.uv.spawn(vim.env.TMUX_PLUGIN_MANAGER_PATH .. "/tmux-window-name/scripts/rename_session_windows.py", {})
		end
	end,
})

-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "BlinkCmpCompletionMenuOpen",
-- 	callback = function()
-- 		require("copilot.suggestion").dismiss()
-- 		vim.b.copilot_suggestion_hidden = true
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "BlinkCmpCompletionMenuClose",
-- 	callback = function()
-- 		vim.b.copilot_suggestion_hidden = false
-- 	end,
-- })
