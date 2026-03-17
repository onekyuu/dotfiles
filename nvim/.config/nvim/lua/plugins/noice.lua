return {
  "folke/noice.nvim",
  opts = {
    notify = {
      enabled = false,
    },
    -- 1. LSP 配置：接管 LSP 的 UI 渲染
    lsp = {
      -- 覆盖 vim.notify 等默认显示
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- 必须开启，否则 cmp 文档会出现边框重叠
      },
      -- 强烈建议：关闭 Noice 的签名帮助 (Signature Help)
      -- 原因：它经常遮挡代码，且 nvim-cmp / blink.cmp 已经自带了更好的提示
      signature = {
        enabled = false,
      },
      -- 悬浮窗文档 (Hover)
      hover = {
        enabled = true,
        silent = true, -- 如果没文档，保持安静不报错
      },
    },

    -- 2. 预设 (Presets)：一键开启常用组合
    presets = {
      -- bottom_search = true, -- 将搜索栏 cmdline (/) 放在底部（像原生 Vim），而不是悬浮在中间
      -- command_palette = true, -- 将命令栏 (:) 放在中间（像 VS Code 的命令面板）
      long_message_to_split = true, -- 如果消息太长（比如报错堆栈），自动分屏显示，而不是截断
      inc_rename = false, -- 如果你没装 inc-rename.nvim 插件，请关掉
      lsp_doc_border = true, -- 给 LSP 文档加边框
    },

    -- 3. 消息路由 (Routes)：核心功能！屏蔽或重定向烦人的消息
    routes = {
      -- 示例 A: 屏蔽 "written" (保存文件) 的消息，因为它太频繁了
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      -- 示例 B: 将某些特定的 Warning 变成迷你通知，不弹大窗
      {
        filter = {
          event = "msg_show",
          kind = "search_count", -- 搜索计数
        },
        opts = { skip = true }, -- 或者用 view = "mini" 显示在右下角
      },
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      },
    },

    -- 4. 视图配置 (Views)：自定义窗口样式
    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
      hover = {
        -- 1. 限制尺寸
        size = {
          max_width = 80, -- 设置最大宽度为 80 字符 (你可以改成 60 或更小)
          width = "auto", -- 宽度自动，但不会超过 max_width
          max_height = 20, -- (可选) 限制最大高度，防止太长
        },
        -- 2. 开启自动换行 (非常重要！否则限制宽度后，长代码会被切掉)
        win_options = {
          wrap = true,
          linebreak = true, -- 在单词边界换行，不切断单词
        },
        -- 3. (可选) 调整边框样式
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
    },
  },
}
