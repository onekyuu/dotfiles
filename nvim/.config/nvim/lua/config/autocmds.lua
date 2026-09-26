-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 强制关闭 Markdown 和 Text 文件的原生拼写检查
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
  end,
})

local save_group = vim.api.nvim_create_augroup("GeekAutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = save_group,
  pattern = "*",
  desc = "Auto save",
  callback = function(ctx)
    local bo = vim.bo[ctx.buf]
    if bo.modified and bo.buftype == "" and vim.fn.bufname(ctx.buf) ~= "" then
      vim.api.nvim_buf_call(ctx.buf, function()
        vim.cmd("silent update")
      end)
    end
  end,
})
