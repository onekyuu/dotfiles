# My Dotfiles

跨 **macOS** 与 **Arch Linux** 的纯键盘流开发环境配置，面向前端（TypeScript / React / Next.js）与 Python 后端开发。通过 GNU Stow 管理软链接，结构严格镜像 `~` 目录。

## 使用操作

安装 git 和 stow：

```bash
# macOS
brew install git stow

# Arch Linux
sudo pacman -S git stow
```

```bash
git clone https://github.com/onekyuu/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

---

## 工具概览

### Doom Emacs — 可编程编辑环境

私有配置位于 [`doom/.config/doom`](./doom/.config/doom)，启用 Evil、Corfu、
Vertico、Dirvish、Eglot、Ruff、Org、Vterm 与自定义 Doom Modeline。macOS
下的 Modeline 会缓存显示 CPU、内存、磁盘、电池和时间；其他系统使用 Doom
默认 Modeline。

### Karabiner-Elements — macOS 键盘映射

当前键盘映射位于
[`karabiner/.config/karabiner/karabiner.json`](./karabiner/.config/karabiner/karabiner.json)。
安装脚本仅在 macOS 部署该配置，并保留 `automatic_backups` 和 `assets` 为本机状态。

### Neovim — 核心编辑器

基于 [LazyVim](https://lazyvim.github.io) 深度定制。LazyVim 提供开箱即用的 LSP、Treesitter、格式化等基础设施，在此之上添加了以下自定义配置。

**语言支持（LazyVim Extras）**

| Extra | 说明 |
|---|---|
| `lang.typescript` | TypeScript / TSX LSP、类型检查 |
| `lang.python` | Pyright LSP、venv 管理 |
| `lang.go` | gopls |
| `lang.java` | jdtls |
| `lang.zig` | zls |
| `lang.markdown` | Markdown 增强渲染与预览 |
| `lang.tailwind` | Tailwind CSS 智能补全 |
| `lang.docker` / `lang.git` / `lang.json` / `lang.yaml` / `lang.toml` | 各格式 schema 与 LSP 支持 |
| `linting.eslint` | ESLint 集成 |
| `editor.fzf` | fzf-lua 模糊搜索后端 |

---

### Nvim 插件详解

#### 补全 & AI

| 插件 | 说明 |
|---|---|
| [blink.cmp](https://github.com/saghen/blink.cmp) | 全 Rust 异步补全引擎，`super-tab` 键位预设，启用签名提示 |
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) | 通过 Codex ACP 使用 ChatGPT 登录进行聊天 |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | 多语言代码片段库 |

#### 格式化 & Lint

| 插件 | 说明 |
|---|---|
| [conform.nvim](https://github.com/stevearc/conform.nvim) | 保存时自动格式化。Lua → `stylua`，Python → `ruff`，JS/TS/JSX/TSX → `biome` |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | 异步 lint。前端用 `biomejs`，Python 用 `ruff`，全局用 `cspell` 检查拼写 |

#### UI & 外观

| 插件 | 说明 |
|---|---|
| [catppuccin](https://github.com/catppuccin/nvim) | 主色方案，`macchiato` 风格 |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | 备用主题，`moon` 风格，侧边栏透明 |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | 备用主题，`wave` 风格 |
| [noice.nvim](https://github.com/folke/noice.nvim) | 重写 cmdline、notify、LSP 文档 UI；屏蔽写入提示等噪音消息 |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | 通知超时设置为 10 秒 |
| [incline.nvim](https://github.com/b0o/incline.nvim) | 浮动文件名栏，显示文件类型图标与诊断计数 |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | 在 buffer 内直接渲染 Markdown 格式（标题、列表、代码块） |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | mini 系列工具集（`mini.ai` 文本对象、`mini.pairs` 括号配对、`mini.icons` 图标） |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | 标签页式 buffer 栏 |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 状态栏 |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | 文件类型图标 |

#### 导航 & 搜索

| 插件 | 说明 |
|---|---|
| [snacks.nvim](https://github.com/folke/snacks.nvim) | 多合一工具：文件树 Explorer、Picker（模糊搜索）、Dashboard、终端浮窗；Explorer 默认显示隐藏文件 |
| [flash.nvim](https://github.com/folke/flash.nvim) | 增强跳转，字符跳转与 Treesitter 跳转 |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | fzf 驱动的搜索后端 |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | 项目级查找与替换 |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | 高亮并搜索 TODO / FIXME / NOTE 等注释 |

#### LSP & 语言

| 插件 | 说明 |
|---|---|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 客户端配置 |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP / DAP / Lint / Format 工具的安装管理器 |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | mason 与 lspconfig 的桥接 |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法树解析，提供语法高亮与结构感知 |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | 基于语法树的文本对象（函数、类等） |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) | HTML / JSX 标签自动闭合与重命名 |
| [ts-comments.nvim](https://github.com/folke/ts-comments.nvim) | 基于 Treesitter 的注释，支持嵌套语言（如 JSX 内的 CSS） |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Neovim Lua API 类型补全 |
| [SchemaStore.nvim](https://github.com/b0omat/SchemaStore.nvim) | JSON / YAML schema 仓库，供 LSP 使用 |
| [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim) | Python 虚拟环境快速切换 |
| [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) | Java LSP 增强 |

#### Git

| 插件 | 说明 |
|---|---|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | 行内 Git diff 标记、blame、hunk 操作 |

#### 效率 & 其他

| 插件 | 说明 |
|---|---|
| [hardtime.nvim](https://github.com/m4xshen/hardtime.nvim) | 强制养成 Vim 高效移动习惯，阻止方向键重复等低效操作 |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Neovim 与 Tmux 窗格无缝导航（`<C-h/j/k/l>`） |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | 按键提示弹窗，显示可用快捷键 |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | 诊断、引用、TODO 的统一列表面板 |
| [persistence.nvim](https://github.com/folke/persistence.nvim) | 自动保存与恢复会话 |
| [fcitx.nvim](https://github.com/h-hg/fcitx.nvim) | 离开 Insert 模式时自动切换到英文输入法（fcitx5） |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | 在浏览器中实时预览 Markdown，默认用 DuckDuckGo 打开 |
| [opencode.lua](./nvim/.config/nvim/lua/plugins/opencode.lua) | 将 OpenCode AI 集成进 Neovim，右侧浮动终端，支持选区发送（`<leader>oc/oC/of/os`） |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua 工具库，多数插件的底层依赖 |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI 组件库 |

---

### Ghostty — 终端模拟器

GPU 加速的现代终端，启动极快，支持 Ligature 字体与真彩色。

### Zsh + Zimfw + Starship

- **Zimfw**：轻量 Zsh 框架，替代 Oh My Zsh，模块化加载速度更快
- **Starship**：跨 Shell 的 Prompt，显示 Git 状态、语言版本、目录等
- **fnm**：Node.js 版本管理，进入目录时自动切换版本（`--use-on-cd`）
- **zoxide**：智能 `cd`，根据访问频率跳转目录
- **eza**：替代 `ls`，带图标与颜色，别名 `ls` / `ll` / `la`

### Yazi — 终端文件管理器

全异步 Rust 文件管理器，支持终端内图片预览。集成 Starship 与 Git 状态插件。`y` 函数退出后自动 `cd` 到最后所在目录。

### Tmux — 终端复用

支持会话持久化。`tm` 函数自动附加或新建以当前目录名命名的会话。与 Neovim 通过 `vim-tmux-navigator` 共享 `<C-h/j/k/l>` 导航。

### CSpell — 拼写检查

维护私人词库，通过 `nvim-lint` 在 Neovim 中对所有文件类型实时检查拼写。
