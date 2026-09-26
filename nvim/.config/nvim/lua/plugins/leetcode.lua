return {
  "kawre/leetcode.nvim",
  cmd = "Leet",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "rcarriga/nvim-notify", -- 可选，用于更美观的通知
  },
  opts = {
    -- --- 基础设置 ---
    domain = "com", -- 关键：确保是美版
    lang = "python3", -- 默认编程语言：python3, cpp, go, java, rust 等

    -- --- 存储设置 ---
    storage = {
      home = "/Volumes/SanDisk/Workspace/leetcode",
      cache = vim.fn.stdpath("cache") .. "/leetcode",
    },

    -- --- UI 设置 ---
    logging = true,
    console = {
      open_on_runcode = true, -- 运行代码时自动打开控制台
      dir = "row", -- 控制台布局：row (水平) 或 col (垂直)
      size = {
        width = "90%",
        height = "70%",
      },
    },

    description = {
      viewport = "width", -- 题目描述窗口宽度适应
    },
  },
  -- --- 快捷键映射 ---
  keys = {
    { "<leader>lc", "<cmd>Leet<cr>", desc = "LeetCode Dashboard" },
    { "<leader>lt", "<cmd>Leet test<cr>", desc = "LeetCode Test" },
    { "<leader>ls", "<cmd>Leet submit<cr>", desc = "LeetCode Submit" },
    { "<leader>li", "<cmd>Leet info<cr>", desc = "LeetCode Detail" },
    { "<leader>lr", "<cmd>Leet random<cr>", desc = "LeetCode Random" },
    { "<leader>ll", "<cmd>Leet list<cr>", desc = "LeetCode List" },
  },
}
