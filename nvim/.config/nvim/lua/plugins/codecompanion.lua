return {
  "olimorris/codecompanion.nvim",
  version = "^19.0.0",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  cmd = { "CodeCompanionChat", "CodeCompanionActions" },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "x" }, desc = "CodeCompanion: Toggle Chat" },
    { "<leader>an", "<cmd>CodeCompanionChat<CR>", desc = "CodeCompanion: New Chat" },
    { "<leader>aa", "<cmd>CodeCompanionActions<CR>", mode = { "n", "x" }, desc = "CodeCompanion: Actions" },
    { "<leader>as", "<cmd>CodeCompanionChat Add<CR>", mode = "x", desc = "CodeCompanion: Add Selection" },
  },
  opts = {
    adapters = {
      acp = {
        codex = function()
          return require("codecompanion.adapters").extend("codex", {
            defaults = { auth_method = "chat-gpt" },
          })
        end,
      },
    },
    interactions = {
      chat = { adapter = "codex" },
    },
  },
}
