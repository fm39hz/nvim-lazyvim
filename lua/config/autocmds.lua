-- Autocmds are automatically loaded on the VeryLazy event

-- Auto format with custom actions
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Format before save with Organize Imports",
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	group = vim.api.nvim_create_augroup("LspFormatConfig", { clear = true }),
	callback = function(ev)
		local conform_opts = { bufnr = ev.buf, lsp_format = "fallback", timeout_ms = 2000 }

		local client = vim.lsp.get_clients({ name = "vtsls", bufnr = ev.buf })[1]

		if client then
			LazyVim.lsp.action["source.organizeImports"]()
			LazyVim.lsp.action["source.fixAll"]()
		end

		require("conform").format(conform_opts)
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Format before save with Organize Imports",
	pattern = { "*.cs", "*.csproj", "*.sln" },
	group = vim.api.nvim_create_augroup("LspFormatConfig", { clear = true }),
	callback = function(ev)
		local conform_opts = { bufnr = ev.buf, lsp_format = "fallback", timeout_ms = 2000 }

		local cs_client = vim.lsp.get_clients({ name = "roslyn_ls", bufnr = ev.buf })[1]

		if cs_client then
			local bufnr = vim.api.nvim_get_current_buf()

			local clients = vim.lsp.get_clients({ name = "roslyn" })
			if not clients or vim.tbl_isempty(clients) then
				vim.notify("Couldn't find client", vim.log.levels.ERROR, { title = "Roslyn" })
				return
			end

			local client = clients[1]
			local action = {
				kind = "quickfix",
				data = {
					CustomTags = { "RemoveUnnecessaryImports" },
					TextDocument = { uri = vim.uri_from_bufnr(bufnr) },
					CodeActionPath = { "Remove unnecessary usings" },
					Range = {
						["start"] = { line = 0, character = 0 },
						["end"] = { line = 0, character = 0 },
					},
					UniqueIdentifier = "Remove unnecessary usings",
				},
			}

			client:request("codeAction/resolve", action, function(err, resolved_action)
				if err then
					vim.notify("Fix using directives failed", vim.log.levels.ERROR, { title = "Roslyn" })
					return
				end
				vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
			end)
		end

		require("conform").format(conform_opts)
	end,
})

local handles = {}

vim.api.nvim_create_autocmd("User", {
	pattern = "RoslynRestoreProgress",
	callback = function(ev)
		local token = ev.data.params[1]
		local handle = handles[token]
		if handle then
			handle:report({
				title = ev.data.params[2].state,
				message = ev.data.params[2].message,
			})
		else
			handles[token] = require("fidget.progress").handle.create({
				title = ev.data.params[2].state,
				message = ev.data.params[2].message,
				lsp_client = {
					name = "roslyn",
				},
			})
		end
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "RoslynRestoreResult",
	callback = function(ev)
		local handle = handles[ev.data.token]
		handles[ev.data.token] = nil

		if handle then
			handle.message = ev.data.err and ev.data.err.message or "Restore completed"
			handle:finish()
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf

		if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
			vim.api.nvim_create_autocmd("InsertCharPre", {
				desc = "Roslyn: Trigger an auto insert on '/'.",
				buffer = bufnr,
				callback = function()
					local char = vim.v.char

					if char ~= "/" then
						return
					end

					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					row, col = row - 1, col + 1
					local uri = vim.uri_from_bufnr(bufnr)

					local params = {
						_vs_textDocument = { uri = uri },
						_vs_position = { line = row, character = col },
						_vs_ch = char,
						_vs_options = {
							tabSize = vim.bo[bufnr].tabstop,
							insertSpaces = vim.bo[bufnr].expandtab,
						},
					}

					-- NOTE: We should send textDocument/_vs_onAutoInsert request only after
					-- buffer has changed.
					vim.defer_fn(function()
						client:request(
							---@diagnostic disable-next-line: param-type-mismatch
							"textDocument/_vs_onAutoInsert",
							params,
							function(err, result, _)
								if err or not result then
									return
								end

								vim.snippet.expand(result._vs_textEdit.newText)
							end,
							bufnr
						)
					end, 1)
				end,
			})
		end
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
