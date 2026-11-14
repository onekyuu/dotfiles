-- Run: nvim --headless -u NONE -i NONE -n -l tests/search-focus.lua
local data = vim.fn.stdpath("data") .. "/lazy/"
vim.opt.rtp:append(data .. "snacks.nvim")
vim.opt.rtp:append(data .. "fzf-lua")
vim.o.columns = 160
vim.o.lines = 40
vim.cmd.filetype("on")
vim.cmd.edit("tests/project-root.lua")
local editor = vim.api.nvim_get_current_win()
require("snacks").setup({ picker = dofile(".config/nvim/lua/plugins/snacks.lua").opts.picker })
local picker = Snacks.picker.explorer({ cwd = vim.fn.getcwd(), watch = false, git_status = false })
assert(
  vim.wait(3000, function()
    return picker.list.win:valid() and not picker:is_active() and vim.api.nvim_get_current_win() == picker.list.win.win
  end, 10),
  "Explorer must receive focus"
)
local spec = dofile(".config/nvim/lua/plugins/fzf.lua")
local opts = type(spec.opts) == "function" and spec.opts(nil, {}) or spec.opts
require("fzf-lua").setup(opts)
vim.schedule(function()
  require("fzf-lua").files({
    cwd = vim.fn.getcwd(),
    raw_cmd = "echo tests/explorer-navigation.lua",
    fzf_opts = { ["--select-1"] = true, ["--exit-0"] = true },
  })
end)
local target = vim.fn.getcwd() .. "/tests/explorer-navigation.lua"
assert(
  vim.wait(5000, function()
    return vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(editor)) == target
  end, 10),
  "Search must open selected file in editor"
)
assert(vim.api.nvim_get_current_win() == editor, "Search must focus editor after selection")
assert(vim.bo.filetype == "lua", "Selected file must have normal filetype events")
assert(
  vim.wait(3000, function()
    local item = picker:current()
    return item and item.file == target
  end, 10),
  "Explorer must follow selected file"
)
picker:close()
print("PASS: Search from Explorer opens and focuses the file, with Explorer following")
