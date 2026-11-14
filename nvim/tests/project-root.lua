-- Run: nvim --headless -u NONE -i NONE -n -l tests/project-root.lua
local data = vim.fn.stdpath("data") .. "/lazy/"
vim.opt.rtp:append(data .. "lazy.nvim")
vim.opt.rtp:append(data .. "LazyVim")
LazyVim = require("lazyvim.util")
dofile(".config/nvim/lua/config/options.lua")
local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp .. "/repo/.git", "p")
vim.fn.mkdir(tmp .. "/repo/frontend", "p")
vim.fn.mkdir(tmp .. "/repo/backend", "p")
tmp = vim.uv.fs_realpath(tmp)
vim.fn.writefile({ "export const value = 1" }, tmp .. "/repo/frontend/main.ts")
vim.fn.writefile({ "value = 1" }, tmp .. "/repo/backend/main.py")
local get_clients = vim.lsp.get_clients
vim.lsp.get_clients = function()
  return { { name = "vtsls", config = {}, root_dir = tmp .. "/repo/frontend" } }
end
local ok, err = pcall(function()
  vim.api.nvim_buf_set_name(0, tmp .. "/repo/frontend/main.ts")
  local root = LazyVim.root()
  assert(root == vim.uv.fs_realpath(tmp .. "/repo"), "Frontend LSP narrowed the repository search root")
  assert(vim.fn.filereadable(root .. "/backend/main.py") == 1, "Backend file is outside the search root")
  vim.fn.delete(tmp .. "/repo/.git", "d")
  LazyVim.root.cache = {}
  assert(LazyVim.root() == vim.uv.fs_realpath(tmp .. "/repo/frontend"), "LSP root fallback failed")
end)
vim.lsp.get_clients = get_clients
vim.fn.delete(tmp, "rf")
assert(ok, err)
print("PASS: repository-wide search root and LSP fallback")
