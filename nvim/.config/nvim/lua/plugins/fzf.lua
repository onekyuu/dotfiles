return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    local actions = require("fzf-lua.actions")
    return vim.tbl_deep_extend("force", opts, {
      winopts = { backdrop = false },
      actions = {
        files = {
          enter = function(selected, opts)
            for _, picker in ipairs(Snacks.picker.get({ source = "explorer" })) do
              if picker:is_focused() and vim.api.nvim_win_is_valid(picker.main) then
                vim.api.nvim_set_current_win(picker.main)
                break
              end
            end
            actions.file_edit_or_qf(selected, opts)
          end,
        },
      },
      files = {
        actions = {
          ["alt-h"] = false,
          ["alt-i"] = false,
          ["ctrl-]"] = { fn = actions.toggle_hidden, reuse = true },
          ["ctrl-o"] = { fn = actions.toggle_ignore, reuse = true },
        },
      },
    })
  end,
}
