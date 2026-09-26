# Keep zsh's tied `path`/`PATH` values unique while preserving order.
typeset -U path PATH

if [[ "$OSTYPE" == "darwin"* ]]; then
	# macOS
	alias ls="ls -G"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	# Arch Linux
	alias ls="ls --color=auto"
	alias update="yay -Syu"
fi
# ==========================================
# 1. 基础环境与路径 (Path)
# ==========================================
export EDITOR="nvim"
export LANG=en_US.UTF-8
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"
export PNPM_HOME="$HOME/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"

path=(
	"$HOME/.config/emacs/bin"
	"$HOME/.kimi-code/bin"
	"$HOME/.local/bin"
	"$BUN_INSTALL/bin"
	"$HOME/.pnpm-global/bin"
	"$PNPM_HOME"
	"$JAVA_HOME/bin"
	"/usr/local/bin"
	$path
)
export PATH

# ==========================================
# 2. 启动 Zim 框架 (替代 Oh My Zsh)
# ==========================================
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# 如果 zim 没编译过，自动下载安装 (可选，防止换电脑后报错)
if [[ ! -e ${ZIM_HOME}/init.zsh ]]; then
	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi
# 初始化 Zim
source ${ZIM_HOME}/init.zsh

if (($+commands[fnm])); then
	eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ==========================================
# 4. 其他语言环境 (Java, Python, Bun, pnpm)
# ==========================================
# Python alias
alias py=/usr/bin/python3

# Bun completion
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ==========================================
# 5. 工具配置 (Claude, DeepSeek, Yazi, Tmux)
# ==========================================
# Gemini
alias gemini='$HOME/.nvm/versions/node/v22.12.0/bin/gemini'

# Claude
export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
claude() {
  local token
  token=$(security find-generic-password \
    -s deepseek-api-token -a "$USER" -w) || return
  ANTHROPIC_AUTH_TOKEN="$token" command claude "$@"
}
export ANTHROPIC_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
export CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash
export CLAUDE_CODE_EFFORT_LEVEL=max


alias proxy='export http_proxy=http://127.0.0.1:7897 https_proxy=http://127.0.0.1:7897; unset all_proxy ALL_PROXY'
alias unproxy='unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY'

uv-publish-secure() {
	local token

	token="$(my-keychain-secret pypi-publish-token)" || return 1

	(
		export UV_PUBLISH_TOKEN="$token"
		command uv publish "$@"
	)
}

# Yazi function
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd <"$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Tmux helper
tm() {
	if [[ -z "$1" ]]; then
		name=$(basename "$PWD" | tr . _)
	else
		name=$1
	fi

	if tmux has-session -t "=$name" 2>/dev/null; then
		tmux attach -t "=$name"
	else
		tmux new -s "$name"
	fi
}


export PAGER="less"
unset GIT_PAGER

# ==========================================
# 6. Aliases (别名)
# ==========================================
# File System
alias ls="eza --icons"
alias ll="eza -l --icons"
alias la="eza -la --icons"
alias work="cd /Volumes/SanDisk/Workspace"
alias yw="y /Volumes/SanDisk/Workspace"

# Config Editing
alias editstarship="nvim ~/.config/starship.toml"
alias editghost="nvim ~/.config/ghostty/config"
alias zshconfig="nvim ~/.zshrc" # 统一用 nvim
alias zimconfig="nvim ~/.zimrc"

# Tools
alias nv="nvim"
alias dt="trans -t zh-CN"
alias dj="trans -t ja"
alias de="trans -t en"
alias dtr="trans -I"
alias cj='aichat -r cn2jp'
alias jc='aichat -r jp2cn'
alias ce='aichat -r cn2en'
alias ec='aichat -r en2cn'

# ==========================================
# 7. Prompt (UI) - 必须放在最后
# ==========================================
# 设置终端标题
precmd() {
	print -Pn "\e]0;%1~\a"
}

# 启动 Starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"
