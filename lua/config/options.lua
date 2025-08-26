-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.spelllang = {}
vim.opt.scrolloff = 1000

-- fold config
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- shell
vim.opt.shell = "fish"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- lsp config
vim.lsp.set_log_level("off")
