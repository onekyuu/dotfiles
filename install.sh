#!/usr/bin/env bash

set -e

echo "🚀 开始部署跨平台 Dotfiles (macOS / Arch Linux)..."

if ! command -v stow &>/dev/null; then
	echo "❌ 致命错误: 未安装 GNU Stow。"
	echo "💡 请先执行: brew install stow (macOS) 或 sudo pacman -S stow (Arch Linux)"
	exit 1
fi

if ! command -v curl &>/dev/null; then
	echo "❌ 致命错误: 未安装 curl。"
	exit 1
fi

DOTFILES_DIR="$HOME/dotfiles"
SYSTEM_NAME="$(uname -s)"
cd "$DOTFILES_DIR"

echo "🛡️  正在扫描并备份已存在的系统默认配置..."
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# 定义需要排雷的路径
TARGETS=(
	"$HOME/.zshrc"
	"$HOME/.zshenv"
	"$HOME/.config/nvim"
	"$HOME/.config/ghostty"
	"$HOME/.config/tmux"
	"$HOME/.config/yazi"
	"$HOME/.config/starship.toml"
	"$HOME/.config/cspell"
)

if [[ "$SYSTEM_NAME" == "Darwin" ]]; then
	TARGETS+=("$HOME/.config/karabiner/karabiner.json")
fi

for target in "${TARGETS[@]}"; do
	if [ -e "$target" ] && [ ! -L "$target" ]; then
		echo "   📦 发现真实文件冲突，正在备份: $target"
		mkdir -p "$BACKUP_DIR"
		mv "$target" "$BACKUP_DIR/"
	fi
done

if [ -d "$BACKUP_DIR" ]; then
	echo "✅ 冲突文件已安全备份至: $BACKUP_DIR"
fi

echo "🔗 正在使用 Stow 映射配置包裹..."
PACKAGES=(zsh nvim ghostty tmux yazi starship cspell)

if [[ "$SYSTEM_NAME" == "Darwin" ]]; then
	PACKAGES+=(karabiner)
fi

for pkg in "${PACKAGES[@]}"; do
	if [ -d "$DOTFILES_DIR/$pkg" ]; then
		echo "   -> 投射: $pkg"
		if [[ "$pkg" == "karabiner" ]]; then
			stow --no-folding "$pkg"
		else
			stow "$pkg"
		fi
	fi
done

echo "⚡ 正在初始化 Zsh 与 Zimfw 环境..."
if [ ! -d "$HOME/.zim" ]; then
	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh || true
else
	echo "   Zimfw 已存在，跳过安装。"
fi

echo ""
echo "🎉 部署完成！你的终极终端与 Neovim 开发环境已满血复活！"
echo "💡 提示："
echo "  1. 请执行 'exec zsh' 或重启终端以应用全部环境变量。"
echo "  2. 首次进入 Neovim 时，LazyVim 和 Avante.nvim 会自动下载并编译依赖，请耐心等待几秒钟。"
