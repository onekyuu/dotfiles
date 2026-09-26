return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft.python = { "ruff_format" }
    opts.formatters_by_ft.c = { "clang_format" }
    opts.formatters_by_ft.cpp = { "clang_format" }
    for _, ft in ipairs({
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "css",
      "graphql",
      "html",
      "json",
      "jsonc",
      "vue",
      "svelte",
      "astro",
    }) do
      opts.formatters_by_ft[ft] = { "biome", "prettier", stop_after_first = true }
    end
    opts.formatters.biome = { require_cwd = true }
  end,
}
