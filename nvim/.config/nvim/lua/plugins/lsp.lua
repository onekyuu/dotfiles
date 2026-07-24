return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
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
