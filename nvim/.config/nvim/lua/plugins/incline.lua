return {
  "b0o/incline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local devicons = require("nvim-web-devicons")

    require("incline").setup({
      window = {
        padding = 0,
        margin = { horizontal = 0, vertical = 0 },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        local ft_icon, ft_color = devicons.get_icon_color(filename)

        local modified = vim.bo[props.buf].modified

        local res = {}

        for _, severity in ipairs({ "Error", "Warn", "Info", "Hint" }) do
          local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[severity:upper()] })
          if n > 0 then
            local icon = " "
            if severity == "Error" then
              icon = " "
            end
            if severity == "Warn" then
              icon = " "
            end
            if severity == "Info" then
              icon = " "
            end
            if severity == "Hint" then
              icon = " "
            end

            table.insert(res, {
              icon .. n,
              group = "DiagnosticSign" .. severity,
            })
          end
        end

        if #res > 0 then
          table.insert(res, { " " })
        end

        if ft_icon then
          table.insert(res, { " ", ft_icon, " ", guifg = ft_color })
        end

        table.insert(res, { " " .. filename .. " ", gui = modified and "bold,italic" or "bold" })

        return {
          res,
          guibg = props.focused and "#3d4052" or "#20222a",
          guifg = "#ffffff",
        }
      end,
    })
  end,
}
