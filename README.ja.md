# My Dotfiles

[简体中文](./README.md) · **日本語** · [English](./README.en.md)

**macOS** と **Arch Linux** 向けの、キーボード操作を中心とした dotfiles です。TypeScript・React・Next.js によるフロントエンド開発と、Python によるバックエンド開発を想定しています。ディレクトリ構成は `~` に対応し、シンボリックリンクは GNU Stow で管理します。

## インストール

Git と GNU Stow をインストールします。

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

## ツール一覧

### Karabiner-Elements — macOS のキー割り当て

キー割り当ての設定ファイルは
[`karabiner/.config/karabiner/karabiner.json`](./karabiner/.config/karabiner/karabiner.json) です。
インストールスクリプトは macOS でのみこの設定を配置し、`automatic_backups` と `assets` はローカルに保持します。

### Neovim — メインエディター

[LazyVim](https://lazyvim.github.io) をベースにしたエディター設定です。LazyVim が標準で提供する LSP、Tree-sitter、フォーマット機能に、以下の設定を追加しています。

**言語サポート（LazyVim Extras）**

| Extra | 説明 |
|---|---|
| `lang.typescript` | TypeScript・TSX の LSP と型チェック |
| `lang.python` | Pyright LSP と仮想環境の管理 |
| `lang.go` | gopls |
| `lang.java` | jdtls |
| `lang.zig` | zls |
| `lang.markdown` | Markdown のレンダリングとプレビューを強化 |
| `lang.tailwind` | Tailwind CSS の補完 |
| `lang.docker` / `lang.git` / `lang.json` / `lang.yaml` / `lang.toml` | 各形式のスキーマと LSP サポート |
| `linting.eslint` | ESLint 連携 |
| `editor.fzf` | fzf-lua を使ったあいまい検索 |

---

### Neovim プラグイン

#### 補完と AI

| プラグイン | 説明 |
|---|---|
| [blink.cmp](https://github.com/saghen/blink.cmp) | Rust 製の非同期補完エンジン。`super-tab` プリセットとシグネチャヘルプを有効化 |
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) | ChatGPT アカウントでログインし、Codex ACP 経由でチャット |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | 複数の言語に対応したコードスニペット集 |

#### フォーマットと lint

| プラグイン | 説明 |
|---|---|
| [conform.nvim](https://github.com/stevearc/conform.nvim) | 保存時に自動整形。Lua は `stylua`、Python は `ruff`、JS・TS・JSX・TSX は `biome` を使用 |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | 非同期で lint を実行。フロントエンドは `biomejs`、Python は `ruff`、スペルチェックは `cspell` を使用 |

#### UI と外観

| プラグイン | 説明 |
|---|---|
| [catppuccin](https://github.com/catppuccin/nvim) | メインのカラースキーム。`macchiato` を使用 |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | サイドバーを透過した代替テーマ `moon` |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | 代替テーマ `wave` |
| [noice.nvim](https://github.com/folke/noice.nvim) | コマンドライン、通知、LSP ドキュメントの表示を変更し、書き込み完了などの定型メッセージを非表示にする |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | 通知を 10 秒で閉じる |
| [incline.nvim](https://github.com/b0o/incline.nvim) | ファイル種別のアイコンと診断件数を表示するフローティングバー |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | 見出し、リスト、コードブロックなどをバッファ内でレンダリング |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | テキストオブジェクト（`mini.ai`）、括弧のペア入力（`mini.pairs`）、アイコン（`mini.icons`）を提供 |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | タブ形式のバッファバー |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | ファイル種別アイコン |

#### 移動と検索

| プラグイン | 説明 |
|---|---|
| [snacks.nvim](https://github.com/folke/snacks.nvim) | ファイルツリー、あいまい検索、ダッシュボード、フローティングターミナルを提供。ファイルツリーには隠しファイルを既定で表示 |
| [flash.nvim](https://github.com/folke/flash.nvim) | 文字検索と Tree-sitter を使ったジャンプ |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | fzf を使った検索バックエンド |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | プロジェクト全体の検索と置換 |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | TODO・FIXME・NOTE などのコメントを強調表示し、検索できるようにする |

#### LSP と言語サポート

| プラグイン | 説明 |
|---|---|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Neovim の言語サーバー設定 |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | 言語サーバー、デバッガー、リンター、フォーマッターのインストールを管理 |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Mason と nvim-lspconfig を連携 |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 構文解析、構文ハイライト、構文を認識した編集 |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Tree-sitter ベースのテキストオブジェクトと移動 |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) | HTML・JSX タグの自動閉じと名前変更 |
| [ts-comments.nvim](https://github.com/folke/ts-comments.nvim) | JSX 内の CSS など、埋め込まれた言語にも対応する Tree-sitter ベースのコメント操作 |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Neovim Lua API の型情報に基づく補完 |
| [SchemaStore.nvim](https://github.com/b0omat/SchemaStore.nvim) | 言語サーバー向けの JSON・YAML スキーマ集 |
| [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim) | Python の仮想環境を切り替える |
| [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) | Java 言語サーバー連携 |

#### Git

| プラグイン | 説明 |
|---|---|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git の差分マーカー、blame、ハンク操作 |

#### 編集支援とユーティリティ

| プラグイン | 説明 |
|---|---|
| [hardtime.nvim](https://github.com/m4xshen/hardtime.nvim) | 矢印キーの連打などを制限し、効率的な Vim の移動操作を促す |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | `<C-h/j/k/l>` で Neovim のウィンドウと tmux のペインを移動 |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | 使えるキーバインドをポップアップに表示 |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | 診断、参照、TODO を一つの一覧で表示 |
| [persistence.nvim](https://github.com/folke/persistence.nvim) | セッションの自動保存と復元 |
| [fcitx.nvim](https://github.com/h-hg/fcitx.nvim) | 挿入モードを抜けると fcitx5 を英字入力に切り替える |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | ブラウザーで Markdown をリアルタイムにプレビュー。既定では DuckDuckGo で開く |
| [opencode.lua](./nvim/.config/nvim/lua/plugins/opencode.lua) | 右側のフローティングターミナルに OpenCode AI を統合し、選択範囲を送信できる（`<leader>oc/oC/of/os`） |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | 多くのプラグインが利用する Lua ユーティリティライブラリ |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI コンポーネントライブラリ |

---

### Ghostty — ターミナルエミュレーター

GPU アクセラレーションを使うモダンなターミナルです。起動が速く、フォントのリガチャとトゥルーカラーに対応します。

### Zsh + Zimfw + Starship

- **Zimfw** は、Oh My Zsh の代わりに使える軽量な Zsh フレームワークで、モジュールを高速に読み込みます。
- **Starship** は、Git の状態、言語のバージョン、カレントディレクトリなどを表示する複数シェル対応のプロンプトです。
- **fnm** は Node.js のバージョンを管理し、ディレクトリ移動時に自動で切り替えます（`--use-on-cd`）。
- **zoxide** は、よく使うディレクトリにすばやく移動できる `cd` コマンドです。
- **eza** は、`ls`・`ll`・`la` のエイリアスにアイコンと色付きの表示を提供します。

### Yazi — ターミナルファイルマネージャー

Rust 製の非同期ファイルマネージャーです。ターミナル内の画像プレビュー、Starship、Git のステータス表示に対応します。`y` 関数で起動すると、Yazi の終了時にシェルも最後に開いていたディレクトリへ移動します。

### tmux — ターミナルマルチプレクサー

ターミナルを閉じてもセッションを保持できます。`tm` 関数はカレントディレクトリ名のセッションを作成し、既存のセッションがあれば接続します。`vim-tmux-navigator` により、Neovim と共通の `<C-h/j/k/l>` で移動できます。

### CSpell — スペルチェック

個人用辞書を使い、`nvim-lint` 経由で Neovim の各ファイルタイプをリアルタイムにスペルチェックします。
