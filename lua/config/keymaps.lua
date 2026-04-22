-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Essential
map({ "n", "v" }, ";", ":", { desc = "Enter command mode", noremap = true, nowait = true })
-- map({ "n", "v" }, "<C-d>", "<C-d>zz", { desc = "Scroll half-page down and center", noremap = true, nowait = true })
-- map({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "Scroll half-page up and center", noremap = true, nowait = true })
