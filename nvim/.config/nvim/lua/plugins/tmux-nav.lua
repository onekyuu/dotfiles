return {
  "christoomey/vim-tmux-navigator",
  keys = {
    ["<C-h>"] = {
      function()
        vim.fn.system("tmux select-pane -L")
      end,
      desc = "Force Tmux Left",
    },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Tmux Down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Tmux Up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Tmux Right" },
  },
}
