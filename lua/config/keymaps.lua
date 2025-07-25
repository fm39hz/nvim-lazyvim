-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Essential
map({ "n", "v" }, ";", ":", { desc = "Enter command mode", noremap = true, nowait = true })
map(
	{ "n", "v" },
	"<leader>uP",
	"<CMD>Precognition toggle<CR>",
	{ desc = "Toggle Precognition", noremap = true, nowait = true }
)

-- Theme
map("n", "<leader>uh", "<CMD>HighlightColors Toggle<CR>", { desc = "Toggle highlighting color", nowait = true })

-- File management
map("n", "<leader>op", "<CMD>Oil<CR>", { desc = "Open parent directory" })
map("n", "<C-_>", "<CMD>ToggleTerm direction=float<CR>", { desc = "Open Floating terminal" })
map("n", "<C-/>", "<CMD>ToggleTerm direction=float<CR>", { desc = "Open Floating terminal" })

-- Markdown
map("n", "<leader>ct", ":lua require('toggle-checkbox').toggle()<CR>", { desc = "Toggle Checkbox" })
map("n", "<leader>pb", function()
	require("gitpad").toggle_gitpad_branch()
end, { desc = "Toogle Gitpad branch" })
map("n", "<leader>pd", function()
	local date_filename = "daily-" .. os.date("%Y-%m-%d.md")
	require("gitpad").toggle_gitpad({ filename = date_filename }) -- or require('gitpad').toggle_gitpad({ filename = date_filename, title = 'Daily notes' })
end, { desc = "Toogle Gitpad Daily notes" })
map("n", "<leader>pf", function()
	local filename = vim.fn.expand("%:p") -- or just use vim.fn.bufname()
	if filename == "" then
		vim.notify("empty bufname")
		return
	end
	filename = vim.fn.pathshorten(filename, 2) .. ".md"
	require("gitpad").toggle_gitpad({ filename = filename }) -- or require('gitpad').toggle_gitpad({ filename = filename, title = 'Current file notes' })
end, { desc = "Toogle Gitpad per file notes" })
map("n", "<leader>ps", "<CMD>Soil<CR>", { desc = "Generate Plant Uml Image" })
map("n", "<leader>po", "<CMD>SoilOpenImg<CR>", { desc = "Open Plant Uml Image" })

-- Git
map("n", "<leader>gb", "<CMD>GitBlameToggle<CR>", { desc = "Toggle Git Blame" })
map("n", "<leader>gS", "<CMD>Telescope git_submodules<CR>", { desc = "Show git submodules" })

-- Development
map("n", "<F6>", "<CMD>CompilerOpen<CR>", { desc = "Open compiler" })
map("n", "<S-F6>", "<CMD>CompilerRedo<CR>", { desc = "Compiler redo" })
map("n", "<S-F7>", "<CMD>CompilerToggleResults<CR>", { desc = "Compiler results" })
map("n", "<leader>ci", "<CMD>Telescope import<CR>", { desc = "Import modules" })

-- AI
map("n", "<leader>cp", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code Panel" })
