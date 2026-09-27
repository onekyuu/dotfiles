-- Run: nvim --headless -u NONE -i NONE -n -l tests/explorer-navigation.lua
local data = vim.fn.stdpath("data") .. "/lazy/"
vim.opt.rtp:append(data .. "snacks.nvim")
vim.opt.rtp:append(data .. "vim-tmux-navigator")
vim.cmd.runtime("plugin/tmux_navigator.vim")
vim.o.columns = 120
vim.o.lines = 40
local spec = dofile(".config/nvim/lua/plugins/snacks.lua")
require("snacks").setup({ picker = spec.opts.picker })
local editor = vim.api.nvim_get_current_win()
local picker = Snacks.picker.explorer({ cwd = vim.fn.getcwd(), watch = false, git_status = false })
assert(
  vim.wait(3000, function()
    return picker.list.win:valid() and vim.api.nvim_get_current_win() == picker.list.win.win
  end, 10),
  "Explorer did not receive focus"
)
local mapping = vim.fn.maparg("<C-l>", "n", false, true)
assert(mapping.callback, "Explorer Ctrl-l mapping missing")
mapping.callback()
local returned = vim.api.nvim_get_current_win() == editor
picker:close()
assert(returned, "Explorer Ctrl-l did not return focus to the editor")
print("PASS: Explorer Ctrl-l returns focus to the editor")
