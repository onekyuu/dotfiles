return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      win = {
        position = "right",
        width = 0.4,
        height = 1.0,
      },
    },
    picker = {
      -- 针对 Explorer (文件树) 的特殊配置
      sources = {
        explorer = {
          hidden = true, -- 默认显示隐藏文件 (.env, .config 等)
          ignored = false, -- 是否显示被 git 忽略的文件 (node_modules 等)，建议保持 false
        },

        -- 如果你也想让 "查找文件" (<Space> f f) 默认显示隐藏文件：
        files = {
          hidden = true,
        },
      },

      -- 或者，你可以设置全局默认值 (影响所有搜索)
      -- hidden = true,
    },
    explorer = {
      keys = {
        -- ✅ 强制向左：直接调用 tmux 命令，不经过 vim 窗口判断
        ["<C-h>"] = {
          function()
            vim.fn.system("tmux select-pane -L")
          end,
          desc = "Force Tmux Left",
        },
        ["<C-j>"] = { "<cmd>TmuxNavigateDown<CR>", desc = "Tmux Down" },
        ["<C-k>"] = { "<cmd>TmuxNavigateUp<CR>", desc = "Tmux Up" },
        ["<C-l>"] = { "<cmd>TmuxNavigateRight<CR>", desc = "Tmux Right" },
      },
    },
    dashboard = {
      enable = true,
      preset = {
      },
    },
  },
}
