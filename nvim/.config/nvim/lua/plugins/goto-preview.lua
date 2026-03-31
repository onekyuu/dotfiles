return {
  {
    "rmagatti/goto-preview",
    event = "BufReadPre",
    config = function()
      require("goto-preview").setup({
        width = 100,
        height = 20,
        default_mappings = false,
        resizing_mappings = false,
        opacity = 10,
      })
    end,
    keys = {
      {
        "gpd",
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        mode = { "n", "v" },
        desc = "Preview Definition",
      },
      {
        "gpt",
        "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
        mode = { "n", "v" },
        desc = "Preview Type Definition",
      },
      { "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", mode = { "n", "v" }, desc = "Close All Previews" },
    },
  },
}
