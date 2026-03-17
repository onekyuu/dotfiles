if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/usr/local/bin:$PATH" # 确保 fcitx5-remote 能被找到
    alias ls="ls -G"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Arch Linux
    alias ls="ls --color=auto"
    alias update="yay -Syu"
fi
# ==========================================
# 1. 基础环境与路径 (Path)
# ==========================================
# Homebrew (尽早加载)
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export LANG=en_US.UTF-8

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

eval "$(fnm env --use-on-cd --shell zsh)"

# ==========================================
# 4. 其他语言环境 (Java, Python, Bun, pnpm)
# ==========================================
# Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# Python alias
alias py=/usr/bin/python3

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
export PATH="$HOME/.pnpm-global/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ==========================================
# 5. 工具配置 (Claude, DeepSeek, Yazi, Tmux)
# ==========================================
# Claude Code
export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
export ANTHROPIC_AUTH_TOKEN="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"
export ANTHROPIC_API_KEY=""
export CLAUDE_CODE_SLOW_MODEL="anthropic/claude-sonnet-4.5"

# DeepSeek
export DEEPSEEK_API_KEY="sk-99d66f8dcc31427888611be7327f123f"

# Gemini
alias gemini='$HOME/.nvm/versions/node/v22.12.0/bin/gemini'

# Fcitx5
export PATH="$HOME/.local/bin:$PATH"

# Yazi function
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
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
    tmux attach -t "$name" || tmux new -s "$name"
}

# Kiro Terminal Integration
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

export PAGER="less"

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

# fnm
FNM_PATH="/opt/homebrew/opt/fnm/bin"
if [ -d "$FNM_PATH" ]; then
  eval "`fnm env --use-on-cd`"
fi
