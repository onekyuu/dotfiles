return {
    "kawre/leetcode.nvim",
    -- build = ":LeetCodeCache", -- 首次安装或更新时建议运行，提高搜索速度
    cmd="Leet",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "rcarriga/nvim-notify", -- 可选，用于更美观的通知
    },
    opts = {
        -- --- 基础设置 ---
        domain = "com",     -- 关键：确保是美版
        lang = "python3",   -- 默认编程语言：python3, cpp, go, java, rust 等

        -- --- 存储设置 ---
        storage = {
            home = "/Volumes/SanDisk/Workspace/leetcode",
            cache = vim.fn.stdpath("cache") .. "/leetcode",
        },

        -- --- UI 设置 ---
        logging = true,
        console = {
            open_on_runcode = true, -- 运行代码时自动打开控制台
            dir = "row",            -- 控制台布局：row (水平) 或 col (垂直)
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
        { "<leader>lc", "<cmd>LeetCode<cr>",          desc = "LeetCode Dashboard" },
        { "<leader>lt", "<cmd>LeetCode test<cr>",     desc = "LeetCode Test" },
        { "<leader>ls", "<cmd>LeetCode submit<cr>",   desc = "LeetCode Submit" },
        { "<leader>li", "<cmd>LeetCode info<cr>",     desc = "LeetCode Detail" },
        { "<leader>lr", "<cmd>LeetCode random<cr>",   desc = "LeetCode Random" },
        { "<leader>ll", "<cmd>LeetCode list<cr>",     desc = "LeetCode List" },
    },
}
