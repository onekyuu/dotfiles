-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.spell = false
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.cmdheight = 0 -- 命令和消息由 Noice 显示，不常驻预留底部空行。
vim.o.exrc = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.g.lazyvim_eslint_auto_format = false
vim.g.lazyvim_prettier_needs_config = true
vim.g.root_spec = { ".git", "lsp", { "lua" }, "cwd" }
