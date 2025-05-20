# Neovim Setup

This section documents my **Neovim** configuration, which is designed to provide a modern, minimal, and powerful development environment. I use **Neovim** as my primary code editor with features like LSP, tree-sitter, and fuzzy finding for speed and efficiency.

## Why Neovim?

- Lightweight and extremely fast
- Native support for **Lua-based configuration**
- Built-in **LSP (Language Server Protocol)** support
- Treesitter integration for **better syntax highlighting**
- Huge ecosystem of modern plugins

---

## 📦 Installation

### macOS (with Homebrew):

```bash
brew install neovim
```

## 📁 Configuration Structure
I follow a modular Lua-based setup. The main files are:

`~/.config/nvim/init.lua `– Entry point

`~/.config/nvim/lua/plugins.lua` – Plugin list (using lazy.nvim or packer)

`~/.config/nvim/lua/core/` – Core settings (keymaps, options, autocommands)

`~/.config/nvim/lua/lsp/` – Language server configurations

`~/.config/nvim/lua/configs/` – Individual plugin configs


## 🚀 Getting Started
After cloning this repo:

```bash
git clone https://github.com/Xenderador/dotfiles.git
cd dotfiles
stow nvim
```
---

## 🧪 Optional Dependencies
Install these for a better experience:

ripgrep: for telescope

```bash 
 brew install ripgrep
```

fd: fast file search

```bash
 brew install fd
```
