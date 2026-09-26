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

vim.keymap.set("n", "<leader>sg", function()
  Snacks.picker.grep({ cwd = vim.fn.getcwd() })
end, { desc = "Grep (Current Working Dir)" })

vim.keymap.set("n", "<leader>sG", function()
  Snacks.picker.grep({ cwd = LazyVim.root() })
end, { desc = "Grep (Project Root Dir)" })

vim.keymap.set("n", "<leader>sd", function()
  local search_dir = vim.fn.input("🔍 Search Dir (Enter for CWD): ", "", "dir")

  if search_dir == "" then
    search_dir = vim.fn.getcwd()
  end

  Snacks.picker.grep({ cwd = search_dir })
end, { desc = "Grep in Dir (Empty for CWD)" })

vim.api.nvim_create_autocmd("TermOpen", {
  desc = "在终端的普通模式下按 <C-/> 强制关闭当前终端",
  callback = function()
    vim.keymap.set("n", "<C-/>", "<cmd>close<CR>", { buffer = true, silent = true })
    -- vim.keymap.set("n", "<C-_>", "<cmd>close<CR>", { buffer = true, silent = true })
  end,
})
