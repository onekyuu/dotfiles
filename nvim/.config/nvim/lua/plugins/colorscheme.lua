return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- 可选: latte, frappe, macchiato, mocha
      transparent_background = false, -- 可选: 是否透明背景
    },
  },
  {

    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
