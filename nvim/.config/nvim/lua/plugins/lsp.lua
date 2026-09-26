return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "clang-format", "rust-analyzer" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typos_lsp = {},
        biome = {},
        html = {},
        cssls = {},
        pyright = {
          settings = { pyright = { disableOrganizeImports = true } },
          -- 修改 Pyright 的客户端能力声明
          capabilities = {
            window = {
              workDoneProgress = false,
            },
          },
        },
      },
    },
  },
}
