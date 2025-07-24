# nvim

## Prerequisites

This configuration requires several types of tools to function properly:

1. **Neovim** (>= 0.11.0) - The editor itself
2. **Language Servers** - Provide LSP support (auto-completion, diagnostics, etc.) for various programming languages
3. **Formatters** - Automatically format code according to language conventions
4. **Essential Tools** - TreeSitter (syntax highlighting), ripgrep (fast search), fd (file finder), fzf (fuzzy finder)

## Installation Philosophy

**You can install these tools using any method you prefer** - package managers (homebrew, apt, yum), language-specific tools (npm, pip, cargo), or manual installation. **The only requirement is that the binaries are available in your system PATH.**

For convenience, we provide detailed installation instructions using [mise](https://mise.jdx.dev) below, but feel free to use your preferred installation method.

## Required Dependencies

### Core Dependencies

- **Node.js** - Required for npm-based language servers (bash-language-server, vscode-langservers-extracted, yaml-language-server, prettier)
- **Python** - Required for Python-based tools (pyright, ruff)
- **Go** - Required for Go-based tools (gopls, goimports)
- **Rust** - Required for Rust development and includes rustfmt formatter

### TreeSitter Requirements

nvim-treesitter uses the main branch and requires the following [prerequisites](https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file#requirements):

- **C compiler** (gcc or clang) - Required to compile parsers
- **Git** - Used by TreeSitter to download parsers
- **Node.js** - Required for some parsers

<details>
<summary><strong>📦 Installation Guide using mise (Click to expand)</strong></summary>

### Quick Start with mise

1. Install mise:

   ```bash
   curl https://mise.run | sh
   ```

2. Install basic runtime environments:

   ```bash
   # Install Node.js (required for npm packages)
   mise use -g node@latest

   # Install Python (required for pipx packages)
   mise use -g python@latest

   # Install uv (pipx backend, improves installation speed)
   mise plugin add uv https://github.com/aniaan/asdf-uv.git
   mise use -g uv@latest

   # Install Go (required for Go tools)
   mise use -g go@latest
   ```

3. Install Rust using rustup:

   ```bash
   # Install Rust using the official rustup installer
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   # Follow the onscreen instructions and restart your shell
   ```

   > **Note**: We use [rustup.rs](https://rustup.rs/) for Rust installation as it provides the most reliable way to manage Rust toolchains and includes rustfmt by default.

4. Install Neovim:

   ```bash
   # Install Neovim using asdf plugin
   mise plugin add neovim https://github.com/aniaan/asdf-neovim.git
   mise use -g neovim@latest
   ```

   > **Note**: mise's pipx functionality uses uvx instead of pipx by default (when uv is installed), which significantly improves Python CLI tool installation speed.

5. Install Language Servers and formatters as needed (refer to detailed tables below)

</details>

## Detailed Tool Requirements

The following tools are required for full functionality. You can install them using any method (homebrew, package managers, language tools, etc.) as long as they're available in your PATH.

### Language Servers

These provide LSP support (auto-completion, diagnostics, go-to-definition, etc.):

| Language   | Binary Name                   | Purpose          | Official Documentation                                                                  |
| ---------- | ----------------------------- | ---------------- | --------------------------------------------------------------------------------------- |
| Bash/Shell | `bash-language-server`        | Shell script LSP | [bash-language-server](https://github.com/bash-lsp/bash-language-server)                |
| Go         | `gopls`                       | Go LSP           | [gopls](https://pkg.go.dev/golang.org/x/tools/gopls)                                    |
| JSON       | `vscode-json-language-server` | JSON/JSONC LSP   | [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) |
| Lua        | `lua-language-server`         | Lua LSP          | [lua-language-server](https://github.com/LuaLS/lua-language-server)                     |
| Python     | `pyright-langserver`          | Python LSP       | [Pyright](https://github.com/microsoft/pyright)                                         |
| Rust       | `rust-analyzer`               | Rust LSP         | [rust-analyzer](https://rust-analyzer.github.io/)                                       |
| TOML       | `taplo`                       | TOML LSP         | [Taplo](https://taplo.tamasfe.dev/)                                                     |
| YAML       | `yaml-language-server`        | YAML LSP         | [yaml-language-server](https://github.com/redhat-developer/yaml-language-server)        |

### Formatters

These are used by conform.nvim for automatic code formatting:

| Language/File Type | Binary Name   | Purpose                 | Official Documentation                                           |
| ------------------ | ------------- | ----------------------- | ---------------------------------------------------------------- |
| Go                 | `goimports`   | Go import organizer     | [goimports](https://pkg.go.dev/golang.org/x/tools/cmd/goimports) |
| Go                 | `gofumpt`     | Go formatter            | [gofumpt](https://github.com/mvdan/gofumpt)                      |
| JSON/JSONC         | `prettier`    | JSON formatter          | [Prettier](https://prettier.io/)                                 |
| Lua                | `stylua`      | Lua formatter           | [StyLua](https://github.com/JohnnyMorganz/StyLua)                |
| Markdown           | `prettier`    | Markdown formatter      | [Prettier](https://prettier.io/)                                 |
| Rust               | `rustfmt`     | Rust formatter          | [rustfmt](https://github.com/rust-lang/rustfmt)                  |
| Shell              | `shfmt`       | Shell script formatter  | [shfmt](https://github.com/mvdan/sh)                             |
| Fish               | `fish_indent` | Fish shell formatter    | [fish](https://fishshell.com/)                                   |
| TOML               | `taplo`       | TOML formatter          | [Taplo](https://taplo.tamasfe.dev/)                              |
| Python             | `ruff`        | Python formatter/linter | [Ruff](https://github.com/astral-sh/ruff)                        |

### Essential Tools

| Binary Name    | Purpose             | Official Documentation                                    |
| -------------- | ------------------- | --------------------------------------------------------- |
| `tree-sitter`  | Syntax highlighting | [Tree-sitter](https://tree-sitter.github.io/tree-sitter/) |
| `rg` (ripgrep) | Fast text search    | [ripgrep](https://github.com/BurntSushi/ripgrep)          |
| `fd`           | Fast file finder    | [fd](https://github.com/sharkdp/fd)                       |
| `fzf`          | Fuzzy finder        | [fzf](https://github.com/junegunn/fzf)                    |

<details>
<summary><strong>📦 Complete mise Installation Commands (Click to expand)</strong></summary>

### Language Servers

| Language   | mise Installation Command                                                                                                              |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| Bash/Shell | `mise use -g npm:bash-language-server@latest`                                                                                          |
| Go         | `mise use -g go:golang.org/x/tools/gopls@latest`                                                                                       |
| JSON       | `mise use -g npm:vscode-langservers-extracted@latest`                                                                                  |
| Lua        | `mise plugin add lua-language-server https://github.com/aniaan/asdf-lua-language-server.git && mise use -g lua-language-server@latest` |
| Python     | `mise use -g pipx:pyright@latest`                                                                                                      |
| Rust       | `mise plugin add rust-analyzer https://github.com/aniaan/asdf-rust-analyzer.git && mise use -g rust-analyzer@latest`                   |
| TOML       | `mise plugin add taplo https://github.com/aniaan/asdf-taplo.git && mise use -g taplo@latest`                                           |
| YAML       | `mise use -g npm:yaml-language-server@latest`                                                                                          |

### Formatters

| Language/File Type | mise Installation Command                                                                          |
| ------------------ | -------------------------------------------------------------------------------------------------- |
| Go (goimports)     | `mise use -g go:golang.org/x/tools/cmd/goimports@latest`                                           |
| Go (gofumpt)       | `mise plugin add gofumpt https://github.com/aniaan/asdf-gofumpt.git && mise use -g gofumpt@latest` |
| JSON/JSONC         | `mise use -g npm:prettier@latest`                                                                  |
| Lua                | `mise plugin add stylua https://github.com/aniaan/asdf-stylua.git && mise use -g stylua@latest`    |
| Markdown           | `mise use -g npm:prettier@latest`                                                                  |
| Shell              | `mise plugin add shfmt https://github.com/aniaan/asdf-shfmt.git && mise use -g shfmt@latest`       |
| TOML               | `mise plugin add taplo https://github.com/aniaan/asdf-taplo.git && mise use -g taplo@latest`       |
| Python             | `mise use -g pipx:ruff@latest`                                                                     |

### Essential Tools

| Tool        | mise Installation Command                                                                                      |
| ----------- | -------------------------------------------------------------------------------------------------------------- |
| tree-sitter | `mise plugin add tree-sitter https://github.com/aniaan/asdf-tree-sitter.git && mise use -g tree-sitter@latest` |
| ripgrep     | `mise plugin add ripgrep https://github.com/aniaan/asdf-ripgrep.git && mise use -g ripgrep@latest`             |
| fd          | `mise plugin add fd https://github.com/aniaan/asdf-fd.git && mise use -g fd@latest`                            |
| fzf         | `mise plugin add fzf https://github.com/aniaan/asdf-fzf.git && mise use -g fzf@latest`                         |

For more mise usage instructions, please refer to: https://mise.jdx.dev/getting-started.html

</details>

## Installing This Neovim Configuration

Once you have installed all the required dependencies, you can install this Neovim configuration:

### Installation Steps

1. **Backup your existing Neovim configuration** (if any):

   ```bash
   # Backup existing config
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this repository** to your Neovim configuration directory:

   ```bash
   # Clone the configuration
   git clone https://github.com/aniaan/nvim.git ~/.config/nvim
   ```

3. **Start Neovim**:

   ```bash
   nvim
   ```

4. **Let the configuration initialize**:
   - The first time you run Neovim, it will automatically install and configure all plugins
   - This may take a few minutes depending on your internet connection
   - Once complete, restart Neovim to ensure everything is loaded properly


That's it! Your Neovim setup should now be ready for development.
