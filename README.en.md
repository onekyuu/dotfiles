# My Dotfiles

[简体中文](./README.md) · [日本語](./README.ja.md) · **English**

Keyboard-first dotfiles for **macOS** and **Arch Linux**, built for frontend development with TypeScript, React, and Next.js and backend development with Python. GNU Stow manages symlinks, and the repository layout mirrors `~`.

## Installation

Install Git and GNU Stow.

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

## Tools

### Karabiner-Elements — macOS keyboard remapping

The keyboard mappings are defined in
[`karabiner/.config/karabiner/karabiner.json`](./karabiner/.config/karabiner/karabiner.json).
The install script deploys this configuration on macOS only and keeps `automatic_backups` and `assets` local.

### Neovim — Main editor

The editor configuration is built on [LazyVim](https://lazyvim.github.io), which provides LSP, Tree-sitter, and formatting out of the box. The sections below describe the customizations.

**Language support (LazyVim Extras)**

| Extra | Description |
|---|---|
| `lang.typescript` | TypeScript and TSX language server and type checking |
| `lang.python` | Pyright LSP and virtual environment management |
| `lang.go` | gopls |
| `lang.java` | jdtls |
| `lang.zig` | zls |
| `lang.markdown` | Enhanced Markdown rendering and preview |
| `lang.tailwind` | Tailwind CSS completion |
| `lang.docker` / `lang.git` / `lang.json` / `lang.yaml` / `lang.toml` | Schemas and language server support for these formats |
| `linting.eslint` | ESLint integration |
| `editor.fzf` | fzf-lua fuzzy search backend |

---

### Neovim plugins

#### Completion and AI

| Plugin | Description |
|---|---|
| [blink.cmp](https://github.com/saghen/blink.cmp) | Asynchronous completion engine written in Rust, with the `super-tab` preset and signature help |
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) | Chat through Codex ACP using your ChatGPT account |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Code snippets for multiple languages |

#### Formatting and linting

| Plugin | Description |
|---|---|
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formats on save with `stylua` for Lua, `ruff` for Python, and `biome` for JS, TS, JSX, and TSX |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Runs linters asynchronously with `biomejs` for frontend code, `ruff` for Python, and `cspell` for spell checking |

#### Interface and appearance

| Plugin | Description |
|---|---|
| [catppuccin](https://github.com/catppuccin/nvim) | Primary colorscheme using the `macchiato` flavor |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Alternative `moon` theme with transparent sidebars |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | Alternative `wave` theme |
| [noice.nvim](https://github.com/folke/noice.nvim) | Custom UI for the command line, notifications, and LSP documentation. Hides routine messages such as file-write confirmations |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | Notifications close after 10 seconds |
| [incline.nvim](https://github.com/b0o/incline.nvim) | Floating filename bar with file type icons and diagnostic counts |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Renders Markdown headings, lists, and code blocks directly in the buffer |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | Mini modules for text objects (`mini.ai`), bracket pairing (`mini.pairs`), and icons (`mini.icons`) |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Tab-style buffer bar |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File type icons |

#### Navigation and search

| Plugin | Description |
|---|---|
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Includes a file explorer, fuzzy picker, dashboard, and floating terminal. The explorer shows hidden files by default |
| [flash.nvim](https://github.com/folke/flash.nvim) | Character-based navigation and Tree-sitter jumps |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | fzf-powered search backend |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | Project-wide search and replace |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlights and searches comments such as TODO, FIXME, and NOTE |

#### LSP and languages

| Plugin | Description |
|---|---|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Language server configuration for Neovim |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Manages installation of language servers, debuggers, linters, and formatters |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Connects Mason and nvim-lspconfig |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax parsing, highlighting, and structure-aware editing |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Text objects and navigation based on Tree-sitter |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) | Automatically closes and renames HTML and JSX tags |
| [ts-comments.nvim](https://github.com/folke/ts-comments.nvim) | Tree-sitter-aware commenting for embedded languages such as CSS in JSX |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Type-aware completion for the Neovim Lua API |
| [SchemaStore.nvim](https://github.com/b0omat/SchemaStore.nvim) | JSON and YAML schemas for language servers |
| [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim) | Switches Python virtual environments |
| [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) | Java language server integration |

#### Git

| Plugin | Description |
|---|---|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Inline Git diff indicators, blame, and hunk actions |

#### Editing and utilities

| Plugin | Description |
|---|---|
| [hardtime.nvim](https://github.com/m4xshen/hardtime.nvim) | Encourages efficient Vim motions by limiting repetitive moves such as repeated arrow-key presses |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Navigates between Neovim windows and tmux panes with `<C-h/j/k/l>` |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Displays available keybindings in a popup |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Unified list for diagnostics, references, and TODOs |
| [persistence.nvim](https://github.com/folke/persistence.nvim) | Automatically saves and restores sessions |
| [fcitx.nvim](https://github.com/h-hg/fcitx.nvim) | Switches fcitx5 to English input when you leave Insert mode |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | Live Markdown preview in the browser, opened with DuckDuckGo by default |
| [opencode.lua](./nvim/.config/nvim/lua/plugins/opencode.lua) | Integrates OpenCode AI in a floating terminal on the right and can send selected text (`<leader>oc/oC/of/os`) |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library used by many plugins |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI component library |

---

### Ghostty — Terminal emulator

A modern GPU-accelerated terminal with fast startup, font ligatures, and true color.

### Zsh + Zimfw + Starship

- **Zimfw** is a lightweight alternative to Oh My Zsh with fast, modular loading.
- **Starship** is a cross-shell prompt that displays Git status, language versions, and the current directory.
- **fnm** manages Node.js versions and switches them automatically when you enter a directory (`--use-on-cd`).
- **zoxide** makes it easier to jump to directories you use often.
- **eza** provides icons and colors for the `ls`, `ll`, and `la` aliases.

### Yazi — Terminal file manager

An asynchronous file manager written in Rust with inline image previews and plugins for Starship and Git status. When Yazi exits, the `y` wrapper changes the shell's working directory to the last directory visited.

### tmux — Terminal multiplexer

Keeps sessions available across terminal restarts. The `tm` function attaches to or creates a session named after the current directory. `vim-tmux-navigator` shares `<C-h/j/k/l>` navigation with Neovim.

### CSpell — Spell checking

Uses a personal dictionary with `nvim-lint` to check spelling in real time across Neovim file types.
