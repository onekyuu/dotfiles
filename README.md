# 🚀 My Universal Dotfiles

这是一个跨越 **macOS** 与 **Arch Linux** 的极速、纯文本、纯键盘流开发者环境配置文件库。
专门为现代化的前端 (TypeScript/React/Next.js) 与 Python 后端开发深度优化。

## 使用操作

安装git和stow
macOS: `brew install git stow`
Arch Linux: `sudo pacman -S git stow`

git clone https://github.com/onekyuu/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh

## 🛠 核心技术栈 (The Tech Stack)

- **核心编辑器**: Neovim (基于 LazyVim 定制)
  - **AI 副驾**: `avante.nvim` (无缝整合 Copilot 与 Claude 3.5 模型)
  - **极速补全**: `blink.cmp` (全 Rust 异步、零 UI 闪烁)
  - **全局检索**: `snacks.picker`
  - **极速代码链**: `Biome` (前端 TS/React 格式化) + `Ruff` (Python 规范修复)
- **终端模拟器**: Ghostty (极速、GPU 加速)
- **Shell & 框架**: Zsh + Zimfw + Starship
- **文件管理器**: Yazi (全异步 Rust 开发，带终端图片预览)
- **终端复用**: Tmux + Zoxide (空间跃迁)
- **全局词库**: CSpell (统一跨端业务拼写检查)

## 📦 目录结构设计

使用 **GNU Stow** 进行软链接管理，目录结构严格镜像系统 `~` 目录：

```text
.
├── cspell/     # 存放 CSpell 全局私人词库 (.config/cspell/...)
├── ghostty/    # 现代 GPU 终端配置 (.config/ghostty/...)
├── nvim/       # 深度调教的 Neovim 大本营 (.config/nvim/...)
├── starship/   # 跨平台 Shell 提示符 (.config/starship.toml)
├── tmux/       # Tmux 配置 (.config/tmux/...)
├── yazi/       # 极速终端文件管理器 (.config/yazi/...)
├── zsh/        # Shell 环境变量配置与别名 (.zshrc, .zimrc...)
├── install.sh  # 一键部署脚本
└── README.md   # 本文档
```
