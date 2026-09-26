# Neovim 配置

基于 [LazyVim](https://www.lazyvim.org/) 的个人配置，覆盖前端、Python、Rust 和 C/C++ 开发。插件版本记录在 `lazy-lock.json`，语言扩展由 `lazyvim.json` 管理。

## 启动与依赖

将本目录下的 `.config/nvim` 放置或链接到 `~/.config/nvim`，启动 Neovim。Lazy 安装插件，Mason 按配置安装语言服务器和工具。

- 使用满足 LazyVim 当前要求的 Neovim，以及 Git、Node.js、Python、ripgrep 和 fd。
- Biome 格式化命令优先查找项目 `node_modules/.bin`，再查找 PATH；Biome 项目建议在开发依赖中安装 `@biomejs/biome`，保持编辑器和 CI 版本一致。
- Rust 编译工具链、C/C++ 编译器和 CMake 需要单独安装；Mason 不负责安装编译器。
- OpenCode 集成需要 tmux 会话及 PATH 中的 `opencode`；CodeCompanion 使用 Codex ACP 和 ChatGPT 登录。

常用管理命令：`:Lazy` 查看插件，`:LazyExtras` 管理扩展，`:Mason` 查看开发工具，`:ConformInfo` 查看格式化工具，`:checkhealth` 检查环境。

## 语言支持

| 语言 | 补全与诊断 | 格式化与项目配置 |
| --- | --- | --- |
| JavaScript / TypeScript / JSX / TSX | vtsls、Biome LSP、ESLint | 有 Biome 配置时优先使用 Biome；否则有 Prettier 配置时使用 Prettier |
| HTML / CSS | HTML、CSS 语言服务；Tailwind CSS 语言服务 | 使用相同的 Biome / Prettier 选择策略 |
| Python | Pyright 类型检查、原生 Ruff 诊断、虚拟环境选择 | 保存只执行 `ruff format`；规则写在项目 `pyproject.toml` 或 Ruff 配置中 |
| Rust | rustaceanvim 管理 rust-analyzer；crates.nvim 提供 Cargo 依赖提示 | rustfmt；项目使用 Cargo，可用 `rust-toolchain.toml` 固定工具链 |
| C / C++ | clangd、clang-tidy 检查、源文件与头文件切换 | clang-format；项目使用 `.clang-format` 和编译数据库 |

此外已启用 Go、Java、Zig、Docker、Git、JSON、Markdown、TOML 和 YAML 扩展。Vue、Svelte、Astro 有格式化映射，但未启用各自的专用语言扩展。

### 前端

- Biome 只有找到 `biome.json` 或 `biome.jsonc` 时才参与 Conform 格式化；同时存在 Biome 和 Prettier 配置时优先选择可用的 Biome。
- Prettier 要求项目有自己的配置。没有这两类配置时，不启用这两个 CLI 格式化工具；LazyVim 的 LSP 格式化回退仍保留。
- Biome 诊断由 LSP 提供，不使用 `nvim-lint` 的 `biomejs` 输出解析器。
- ESLint 保留诊断和代码操作，关闭自动格式化，避免保存时重复修改。
- 同一项目同时使用 Biome 和 ESLint 时，在项目中明确两者的规则分工。

### Python

- Pyright 负责类型检查、补全和导航；Ruff 负责 lint、修复和整理 import。Pyright 的 import 整理已关闭，Ruff 的 hover 由官方 Python 扩展关闭，保留 Pyright 的文档提示。
- `<leader>cv` 选择虚拟环境；项目规则和类型检查强度放在 `pyproject.toml` 或 `pyrightconfig.json` 中。
- 保存只格式化，不执行 `ruff check --fix`，避免删除编辑过程中暂未使用的 import。
- 使用 `<leader>ca` 显式执行修复或整理 import；若希望 lint 修复包含 import 排序，在项目 Ruff 规则中启用 `I`。

### Rust

启用官方 `lang.rust` 扩展，由 rustaceanvim 独立管理 rust-analyzer，避免通过 lspconfig 重复启动。Mason 确保安装 rust-analyzer；Rust 工具链建议使用 rustup 管理：

```sh
rustup component add rustfmt clippy
```

如希望直接使用工具链配套的 rust-analyzer，也可执行 `rustup component add rust-analyzer`。实际选中的可执行文件取决于 Neovim 的 PATH。

使用 Cargo 创建和构建项目：

```sh
cargo new hello-rust
cd hello-rust
cargo check
cargo fmt
cargo clippy
```

`<leader>cR` 打开 Rust 专用代码操作。未启用 DAP 或测试运行器扩展；官方 Rust 扩展会声明 CodeLLDB 工具依赖，但调试工作流还需要相应扩展。

### C / C++

启用官方 `lang.clangd` 扩展，Mason 安装 clangd 和 clang-format。`<leader>ch` 切换源文件与头文件。

CMake 项目生成编译数据库，让 clangd 使用真实的头文件路径、宏定义和编译参数：

```sh
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
```

将代码风格写入项目 `.clang-format`；语言标准和编译选项由项目构建配置决定。当前未启用 C/C++ 调试扩展。

## 自动保存与格式化

- `BufLeave`：离开当前文件缓冲区时保存，包括切换文件、进入显示其他文件的分屏或标签页。
- `FocusLost`：Neovim 失去焦点时保存；切换应用是否产生此事件取决于终端和 tmux 的支持。
- 不在 `InsertLeave` 时保存，退出插入模式不会触发自动保存。
- 仅保存事件对应的、已修改的、有文件名的普通缓冲区，不执行全局 `wall`；未命名文件和终端等特殊缓冲区不会自动保存。
- 保存沿用 LazyVim 自动格式化，Conform 超时为默认的 3000ms；写入失败会显示错误。
- 禁用 swap 和 backup，保留 LazyVim 的持久化 undo；启用 `exrc` 支持项目本地配置。

## 常用快捷键

`<leader>` 为空格；除另有说明外，以下按键在普通模式使用。

| 按键 | 功能 |
| --- | --- |
| 插入模式 `jk` | 退出插入模式 |
| `te` | 输入 `:tabedit` 命令，填写文件名或回车新建标签页 |
| `<Tab>` | 下一个标签页 |
| `<leader>sg` / `<leader>sG` | 搜索当前工作目录 / 项目根目录 |
| `<leader>sd` | 指定目录搜索，留空使用当前工作目录 |
| `gd` / `<leader>ca` | 跳转定义 / 代码操作 |
| `gpd` / `gpt` / `gP` | 预览定义 / 类型定义 / 关闭预览 |
| `<leader>cv` | Python 虚拟环境选择 |
| `<leader>cR` | Rust 专用代码操作 |
| `<leader>ch` | C/C++ 源文件与头文件切换 |
| `<leader>ac` / `<leader>an` | 切换 CodeCompanion 聊天 / 新建聊天 |
| `<leader>aa` / 可视模式 `<leader>as` | CodeCompanion 操作面板 / 添加选中内容 |
| `<leader>oa` | OpenCode 提问；普通模式携带当前缓冲区，可视模式携带选中内容 |
| 终端缓冲区的普通模式 `<C-/>` | 关闭当前终端窗口 |
| `<leader>lc` / `<leader>lt` / `<leader>ls` | LeetCode 面板 / 测试 / 提交 |
| `<leader>li` / `<leader>lr` / `<leader>ll` | LeetCode 详情 / 随机题 / 题目列表 |

CodeCompanion 聊天内：`<C-s>` 发送，`<C-c>` 关闭，`q` 停止请求，`?` 查看按键。

## 界面与辅助工具

- Blink：LSP、路径、代码片段和缓冲区补全；使用 super-tab 按键方案，`<C-j>` / `<C-k>` 选择下一项 / 上一项，启用签名提示。
- Catppuccin Macchiato 为默认主题；Tokyo Night、Kanagawa 为备用主题。
- Snacks 提供终端、文件浏览和 Dashboard；fzf-lua 用于官方 FZF 扩展的搜索操作，自定义 grep 按键调用 Snacks picker。
- Incline、Lualine、Noice 和 nvim-notify 提供文件名、状态栏与消息界面；Noice 签名提示关闭，使用 Blink 的提示。
- typos-lsp 提供拼写诊断，项目例外写入 `_typos.toml`；原生 spell 关闭。
- nvim-surround、vim-tmux-navigator、goto-preview、hardtime 和 fcitx.nvim 提供编辑、导航及输入法辅助。
- Markdown 使用 markdown-preview 和 render-markdown。
- OpenCode 在名为 `opencode` 的 tmux 窗口运行；当前配置不是 Snacks 终端集成。
- LeetCode 默认使用国际站和 Python 3，题目存储目录为 `/Volumes/SanDisk/Workspace/leetcode`；其他机器需修改该路径。

## 配置文件与验证

| 文件 | 用途 |
| --- | --- |
| `lazyvim.json` | 官方语言和功能扩展 |
| `lazy-lock.json` | 插件版本锁定 |
| `lua/config/options.lua` | 基础设置、ESLint / Prettier 策略 |
| `lua/config/autocmds.lua` | 自动保存与拼写设置 |
| `lua/config/keymaps.lua` | 自定义快捷键 |
| `lua/plugins/lsp.lua` | 语言服务与 Mason 工具安装 |
| `lua/plugins/conform.lua` | 项目格式化工具选择 |
| `lua/plugins/codecompanion.lua` / `opencode.lua` | AI 集成 |

安装现有依赖后，在此仓库的 `nvim` 目录运行：

```sh
nvim --headless -u NONE -i NONE -l tests/development.lua
```

检查覆盖 Biome / Prettier 选择、Python import 保留、切换文件及失去焦点自动保存，以及真实 Biome LSP 的诊断位置和级别。Rust/C++ 项目的编译、语言服务和调试不在该检查范围内。
