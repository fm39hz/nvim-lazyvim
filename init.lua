if vim.loader then
  vim.loader.enable()
end
require("config.lazy")
vim.cmd("colorscheme ex-everforest")
if vim.g.neovide then
  vim.o.guifont = "JetBrains Mono:h15:b"
  vim.g.neovide_refresh_rate = 170
end
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
