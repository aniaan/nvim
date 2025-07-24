#!/bin/bash

set -e

echo "🚀 Installing Neovim configuration dependencies using mise..."

# Check if mise is installed
if ! command -v mise &> /dev/null; then
    echo "❌ mise is not installed. Please install mise first:"
    echo "   curl https://mise.run | sh"
    exit 1
fi

echo "📦 Installing basic runtime environments..."

# Install basic runtime environments
mise use -g node@latest
mise use -g python@latest
mise use -g go@latest

# Install uv (pipx backend)
mise plugin add uv https://github.com/aniaan/asdf-uv.git 2>/dev/null || true
mise use -g uv@latest

# Install Neovim
mise plugin add neovim https://github.com/aniaan/asdf-neovim.git 2>/dev/null || true
mise use -g neovim@latest

echo "🔧 Installing Language Servers..."

# npm-based language servers
mise use -g npm:bash-language-server@latest
mise use -g npm:vscode-langservers-extracted@latest
mise use -g npm:yaml-language-server@latest

# Go tools
mise use -g go:golang.org/x/tools/gopls@latest
mise use -g go:golang.org/x/tools/cmd/goimports@latest

# pipx-based tools
mise use -g pipx:pyright@latest
mise use -g pipx:ruff@latest

# asdf plugin-based tools
echo "🔧 Installing tools via asdf plugins..."

plugins=(
    "lua-language-server https://github.com/aniaan/asdf-lua-language-server.git"
    "rust-analyzer https://github.com/aniaan/asdf-rust-analyzer.git"
    "taplo https://github.com/aniaan/asdf-taplo.git"
    "gofumpt https://github.com/aniaan/asdf-gofumpt.git"
    "stylua https://github.com/aniaan/asdf-stylua.git"
    "shfmt https://github.com/aniaan/asdf-shfmt.git"
    "tree-sitter https://github.com/aniaan/asdf-tree-sitter.git"
    "ripgrep https://github.com/aniaan/asdf-ripgrep.git"
    "fd https://github.com/aniaan/asdf-fd.git"
    "fzf https://github.com/aniaan/asdf-fzf.git"
)

for plugin_info in "${plugins[@]}"; do
    plugin_name=$(echo $plugin_info | cut -d' ' -f1)
    plugin_url=$(echo $plugin_info | cut -d' ' -f2)

    echo "   Installing $plugin_name..."
    mise plugin add $plugin_name $plugin_url 2>/dev/null || true
    mise use -g $plugin_name@latest
done

# npm-based formatters
echo "🎨 Installing formatters..."
mise use -g npm:prettier@latest

echo "✅ All dependencies installed successfully!"
echo ""
echo "📝 Next steps:"
echo "   1. Install Rust using rustup: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
echo "   2. Clone this configuration: git clone https://github.com/aniaan/nvim.git ~/.config/nvim"
echo "   3. Start Neovim: nvim"
echo ""
echo "🔍 Note: Make sure you have a C compiler (gcc/clang), Git, and Node.js installed for TreeSitter."
