-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--- Esc
keymap.set("i", "jk", "<Esc>", opts)

--- New tab
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)

vim.keymap.set("n", "<leader>ua", function()
  -- 引入必要的模块
  local client = require("copilot.client")
  local command = require("copilot.command")

  -- client.is_disabled() 会告诉你当前是否处于禁用状态
  if client.is_disabled() then
    -- 如果是禁用的，则启用
    command.enable()
    vim.notify("🤖 Copilot: 已启动 (Enabled)", vim.log.levels.INFO)
  else
    -- 如果是启用的，则禁用
    command.disable()
    vim.notify("🔕 Copilot: 已禁用 (Disabled)", vim.log.levels.WARN)
  end
end, { desc = "Toggle Copilot Enable/Disable" })
