return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typos_lsp = {},
        pyright = {
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
