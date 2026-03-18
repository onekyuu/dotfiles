return {
  "folke/snacks.nvim",
  keys = (function()
    local term = nil
    local win_opts = {
      win = {
        position = "right",
        width = 0.40,
        height = 1.0,
        border = "rounded",
        title = " OpenCode ",
        title_pos = "center",
      },
      auto_insert = true,
      env = {
        TERM = "xterm-256color",
        COLORTERM = "truecolor",
      },
    }

    local function toggle()
      if term and term:buf_valid() then
        term:toggle()
      else
        term = Snacks.terminal.open("opencode", win_opts)
      end
    end

    local function new_session()
      term = nil
      term = Snacks.terminal.open("opencode", win_opts)
    end

    local function send_selection()
      local buf = vim.api.nvim_get_current_buf()
      local start_line = vim.fn.line("'<") - 1
      local end_line = vim.fn.line("'>")
      local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
      local ft = vim.bo[buf].filetype
      local filename = vim.fn.expand("%:t")
      local text = string.format("```%s\n-- %s:%d-%d\n%s\n```\n", ft, filename, start_line + 1, end_line, table.concat(lines, "\n"))
      if term and term:buf_valid() then
        local chan = vim.b[term.buf].terminal_job_id
        if chan then
          vim.api.nvim_chan_send(chan, text)
          return
        end
      end
      vim.notify("OpenCode terminal is not open", vim.log.levels.WARN)
    end

    local function add_files()
      Snacks.picker.files({
        confirm = function(picker, item)
          local items = picker:selected({ fallback = true })
          picker:close()
          if #items == 0 then return end
          local paths = {}
          for _, it in ipairs(items) do
            table.insert(paths, "@" .. it.cwd .. "/" .. it.file)
          end
          local text = table.concat(paths, " ") .. " "
          if term and term:buf_valid() then
            local chan = vim.b[term.buf].terminal_job_id
            if chan then
              vim.api.nvim_chan_send(chan, text)
              return
            end
          end
          vim.notify("OpenCode terminal is not open", vim.log.levels.WARN)
        end,
      })
    end

    return {
      { "<leader>oc", toggle, mode = { "n", "t" }, desc = "Toggle OpenCode" },
      { "<leader>oC", new_session, desc = "New OpenCode Session" },
      { "<leader>of", add_files, desc = "Add files to OpenCode prompt" },
      { "<leader>os", send_selection, mode = "v", desc = "Send selection to OpenCode" },
    }
  end)(),
}
