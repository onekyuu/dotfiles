return {
  "nickjvandyke/opencode.nvim",

  -- init 函数会在插件被真正加载前执行，非常适合用来设置 vim.g.* 这样的全局变量
  init = function()
    local opencode_window = "opencode"
    local opencode_cmd = "opencode --port"

    local function tmux_window_exists()
      local windows = vim.fn.systemlist({ "tmux", "list-windows", "-F", "#W" })
      return vim.tbl_contains(windows, opencode_window)
    end

    vim.g.opencode_opts = {
      server = {
        start = function()
          if not tmux_window_exists() then
            vim.fn.system({ "tmux", "new-window", "-d", "-n", opencode_window, opencode_cmd })
          end
        end,
        stop = function()
          if tmux_window_exists() then
            vim.fn.system({ "tmux", "kill-window", "-t", opencode_window })
          end
        end,
        toggle = function()
          if tmux_window_exists() then
            vim.fn.system({ "tmux", "select-window", "-t", opencode_window })
          else
            vim.fn.system({ "tmux", "new-window", "-n", opencode_window, opencode_cmd })
          end
        end,
      },
    }
  end,

  -- 使用 keys 替代底部的 vim.keymap.set，以支持 Lazy 的快捷键懒加载特性
  keys = {
    {
      "<leader>oa",
      function()
        require("opencode").ask("@buffer: ")
      end,
      mode = "n",
      desc = "OpenCode: Ask Buffer",
    },
    {
      "<leader>oa",
      function()
        require("opencode").ask("@this: ")
      end,
      mode = "v",
      desc = "OpenCode: Ask Selection",
    },
  },
}
