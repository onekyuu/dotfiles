-- Run: nvim --headless -u NONE -i NONE -n -l tests/startup-focus.lua
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/snacks.nvim")
vim.o.columns = 160
vim.o.lines = 40
require("snacks").setup({ picker = dofile(".config/nvim/lua/plugins/snacks.lua").opts.picker })
local editor = vim.api.nvim_get_current_win()
local function open()
  local picker = Snacks.picker.explorer({ cwd = vim.fn.getcwd(), watch = false, git_status = false })
  assert(
    vim.wait(3000, function()
      return picker.list.win:valid() and not picker:is_active() and picker:is_focused()
    end, 10),
    "Explorer must initially receive focus"
  )
  return picker
end
local picker = open()
dofile(".config/nvim/lua/config/autocmds.lua")
assert(
  vim.wait(3000, function()
    return vim.api.nvim_get_current_win() == editor
  end, 10),
  "Startup must focus the editor"
)
assert(picker.list.win:valid(), "Startup must keep Explorer visible")
vim.wait(100, function()
  return false
end, 10)
assert(vim.wait(3000, function()
  return not picker:is_active()
end, 10))
picker:close()
vim.wait(50, function()
  return false
end, 10)
local manual = open()
assert(manual:is_focused(), "Manually opening Explorer must still focus it")
manual:close()
print("PASS: Startup focuses editor; manual Explorer opening retains focus")
