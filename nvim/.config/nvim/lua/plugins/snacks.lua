return {
  "folke/snacks.nvim",
  opts = {
    lazygit = {
      win = {
        position = "float",
        width = 0,
        height = 0,
        border = "none",
      },
    },
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
          win = {
            list = {
              keys = {
                -- ✅ 强制向左：直接调用 tmux 命令，不经过 vim 窗口判断
                ["<C-h>"] = {
                  function()
                    vim.fn.system("tmux select-pane -L")
                  end,
                  desc = "Force Tmux Left",
                },
                ["<C-j>"] = {
                  function()
                    vim.cmd.TmuxNavigateDown()
                  end,
                  desc = "Tmux Down",
                },
                ["<C-k>"] = {
                  function()
                    vim.cmd.TmuxNavigateUp()
                  end,
                  desc = "Tmux Up",
                },
                ["<C-l>"] = {
                  function()
                    vim.cmd.TmuxNavigateRight()
                  end,
                  desc = "Tmux Right",
                },
              },
            },
          },
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
      enabled = true,
      replace_netrw = true,
    },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "G", desc = "LazyGit", action = ":lua Snacks.lazygit()" },
          { icon = "󰚩 ", key = "a", desc = "CodeCompanion", action = ":CodeCompanionChat Toggle" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = ([[
 ██████╗ ███╗   ██╗███████╗██╗  ██╗██╗   ██╗██╗   ██╗██╗   ██╗      ██╗      █████╗ ██████╗
██╔═══██╗████╗  ██║██╔════╝██║ ██╔╝╚██╗ ██╔╝██║   ██║██║   ██║      ██║     ██╔══██╗██╔══██╗
██║   ██║██╔██╗ ██║█████╗  █████╔╝  ╚████╔╝ ██║   ██║██║   ██║      ██║     ███████║██████╔╝
██║   ██║██║╚██╗██║██╔══╝  ██╔═██╗   ╚██╔╝  ██║   ██║██║   ██║      ██║     ██╔══██║██╔══██╗
╚██████╔╝██║ ╚████║███████╗██║  ██╗   ██║   ╚██████╔╝╚██████╔╝      ███████╗██║  ██║██████╔╝
 ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝       ╚══════╝╚═╝  ╚═╝╚═════╝
]]):gsub("[^\n]+", function(line)
          return line .. string.rep(" ", 92 - vim.fn.strdisplaywidth(line))
        end),
      },
    },
  },
}
