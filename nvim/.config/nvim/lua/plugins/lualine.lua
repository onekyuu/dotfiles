return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, 1, {
      function()
        local root = LazyVim.root()
        local formatted_root = vim.fn.fnamemodify(root, ":~")
        return "󱉭 Root: " .. formatted_root
      end,
      color = { fg = "#fab387", gui = "bold" },
    })
  end,
}
