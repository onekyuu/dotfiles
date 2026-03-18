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
  local client = require("copilot.client")
  local command = require("copilot.command")

  if client.is_disabled() then
    command.enable()
    vim.notify("🤖 Copilot: 已启动 (Enabled)", vim.log.levels.INFO)
  else
    command.disable()
    vim.notify("🔕 Copilot: 已禁用 (Disabled)", vim.log.levels.WARN)
  end
end, { desc = "Toggle Copilot Enable/Disable" })
