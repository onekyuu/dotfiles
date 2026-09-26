# 💤 LazyVim 配置总结

这是一个基于 [LazyVim](https://github.com/LazyVim/LazyVim) 的 Neovim 配置。

## ⚙️ 核心设置 (`lua/config/options.lua`)
- 禁用拼写检查 (`spell = false`)
- 启用 `exrc` (支持本地项目配置)
- 禁用 swap/backup 文件，保持工作区整洁

## ⌨️ 快捷键 (`lua/config/keymaps.lua`)
- **插入模式**: `jk` 映射为 `<Esc>`
- **标签页**: `te` 新建标签页，`<tab>` 切换下一个标签页
- **CodeCompanion**: `<leader>ac` 打开/隐藏聊天，`<leader>an` 新建聊天，`<leader>aa` 打开操作面板，选中文本后 `<leader>as` 添加到聊天
  - 聊天窗口内：`<C-s>` 发送，`<C-c>` 关闭，`q` 停止请求，`?` 查看全部按键
- **搜索**:
  - `<leader>sg`: 在当前工作目录 (CWD) 中 grep
  - `<leader>sG`: 在项目根目录中 grep
  - `<leader>sd`: 在指定目录中 grep
- **终端**: 在终端模式下 `<C-/>` 可强制关闭当前终端

## 🧩 插件列表与详细功能

### 补全与 AI
- `blink.cmp`: 高性能代码补全引擎。
- `codecompanion.nvim`: 通过 Codex ACP 使用 ChatGPT 订阅聊天（`:CodeCompanionChat`）。

### 格式化与 Lint
- `conform.nvim`: 代码自动格式化工具。
- `nvim-lint`: 代码静态检查工具。

### UI 与外观
- `catppuccin`: Catppuccin Macchiato 配色方案。
- `tokyonight.nvim`: Tokyo Night Moon 备用配色方案。
- `kanagawa.nvim`: Kanagawa Wave 备用配色方案。
- `incline.nvim`: 浮动文件名显示。
- `lualine.nvim`: 状态栏增强。
- `noice.nvim`: 优化 LSP 文档边框和 UI 消息。
- `nvim-notify`: 优化通知显示。

### 工具与效率
- `snacks.nvim`: 综合工具集（包含终端、文件搜索、Dashboard 等）。
- `fcitx.nvim`: Fcitx5 输入法自动切换支持。
- `goto-preview`: 定义预览功能。
- `hardtime.nvim`: 强制养成良好的 Vim 操作习惯。
- `markdown-preview.nvim`: Markdown 实时预览。
- `render-markdown.nvim`: Markdown 渲染增强。
- `nvim-surround`: 文本环绕操作（添加/删除/修改引号、括号等）。
- `vim-tmux-navigator`: Tmux 与 Neovim 窗口导航集成。

### 关键插件亮点
- **OpenCode 集成 (`lua/plugins/opencode.lua`)**:
  - 使用 `snacks.nvim` 实现 OpenCode 终端集成。
  - `<leader>oc`: 切换 OpenCode 终端
  - `<leader>oC`: 新建 OpenCode 会话
  - `<leader>of`: 添加文件到 OpenCode 提示词
  - `<leader>os`: 在可视模式下将选中内容发送到 OpenCode

---
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.
