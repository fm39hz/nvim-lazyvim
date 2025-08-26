-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.spelllang = {}
vim.opt.scrolloff = 1000

-- fold config
vim.opt.foldmethod = "manual"
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- shell
vim.opt.shell = "fish"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- lsp config
vim.lsp.set_log_level("off")
