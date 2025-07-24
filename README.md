# nvim

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation Philosophy](#installation-philosophy)
- [Required Dependencies](#required-dependencies)
  - [Core Dependencies](#core-dependencies)
  - [TreeSitter Requirements](#treesitter-requirements)
- [Required Tools Overview](#required-tools-overview)
- [Installation Guide](#installation-guide)
  - [Dependencies Installation](#dependencies-installation)
  - [Configuration Installation](#configuration-installation)

## Overview

This is a modern Neovim configuration focused on providing a comprehensive development environment with LSP support, code formatting, and essential development tools. The configuration supports multiple programming languages including Go, Python, Rust, Lua, Shell scripting, and various markup/configuration formats.

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



## Required Tools Overview

The following tools are required for full functionality. You can install them using any method (homebrew, package managers, language tools, etc.) as long as they're available in your PATH.

| Category         | Tool Name            | Binary Name                   | Type          | Purpose                    | Official Documentation                                                                  |
| ---------------- | -------------------- | ----------------------------- | ------------- | -------------------------- | --------------------------------------------------------------------------------------- |
| **Go**           | gopls                | `gopls`                       | LSP           | Go language server         | [gopls](https://pkg.go.dev/golang.org/x/tools/gopls)                                    |
|                  | goimports            | `goimports`                   | Formatter     | Go import organizer        | [goimports](https://pkg.go.dev/golang.org/x/tools/cmd/goimports)                        |
|                  | gofumpt              | `gofumpt`                     | Formatter     | Go formatter               | [gofumpt](https://github.com/mvdan/gofumpt)                                             |
| **Python**       | Pyright              | `pyright-langserver`          | LSP           | Python language server     | [Pyright](https://github.com/microsoft/pyright)                                         |
|                  | Ruff                 | `ruff`                        | Formatter     | Python formatter/linter    | [Ruff](https://github.com/astral-sh/ruff)                                               |
| **Rust**         | rust-analyzer        | `rust-analyzer`               | LSP           | Rust language server       | [rust-analyzer](https://rust-analyzer.github.io/)                                       |
|                  | rustfmt              | `rustfmt`                     | Formatter     | Rust formatter             | [rustfmt](https://github.com/rust-lang/rustfmt)                                         |
| **Lua**          | lua-language-server  | `lua-language-server`         | LSP           | Lua language server        | [lua-language-server](https://github.com/LuaLS/lua-language-server)                     |
|                  | StyLua               | `stylua`                      | Formatter     | Lua formatter              | [StyLua](https://github.com/JohnnyMorganz/StyLua)                                       |
| **Shell**        | bash-language-server | `bash-language-server`        | LSP           | Shell script LSP           | [bash-language-server](https://github.com/bash-lsp/bash-language-server)                |
|                  | shfmt                | `shfmt`                       | Formatter     | Shell script formatter     | [shfmt](https://github.com/mvdan/sh)                                                    |
|                  | fish_indent          | `fish_indent`                 | Formatter     | Fish shell formatter       | [fish](https://fishshell.com/)                                                          |
| **Web/Markup**   | vscode-langservers   | `vscode-json-language-server` | LSP           | JSON/JSONC language server | [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) |
|                  | Prettier             | `prettier`                    | Formatter     | JSON/Markdown formatter    | [Prettier](https://prettier.io/)                                                        |
| **Config Files** | Taplo                | `taplo`                       | LSP+Formatter | TOML language server       | [Taplo](https://taplo.tamasfe.dev/)                                                     |
|                  | yaml-language-server | `yaml-language-server`        | LSP           | YAML language server       | [yaml-language-server](https://github.com/redhat-developer/yaml-language-server)        |
| **Essential**    | Tree-sitter          | `tree-sitter`                 | Tool          | Syntax highlighting        | [Tree-sitter](https://tree-sitter.github.io/tree-sitter/)                               |
|                  | ripgrep              | `rg`                          | Tool          | Fast text search           | [ripgrep](https://github.com/BurntSushi/ripgrep)                                        |
|                  | fd                   | `fd`                          | Tool          | Fast file finder           | [fd](https://github.com/sharkdp/fd)                                                     |
|                  | fzf                  | `fzf`                         | Tool          | Fuzzy finder               | [fzf](https://github.com/junegunn/fzf)                                                  |

## Installation Guide

### Dependencies Installation

We provide an automated installation script that installs all dependencies at once. See `install-deps.sh` for the complete installation process.

Alternatively, you can install each tool manually using your preferred method - the only requirement is that the binaries are available in your system PATH.

### Configuration Installation

Once you have installed all the required dependencies, you can install this Neovim configuration:

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
