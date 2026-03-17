return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.cmd([[
      function! OpenInDuckDuckGo(url)
        execute "silent ! open -a DuckDuckGo '" . a:url . "'"
      endfunction
      let g:mkdp_browserfunc = 'OpenInDuckDuckGo'
    ]])

    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
  end,
  ft = { "markdown" },
}
