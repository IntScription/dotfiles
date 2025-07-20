#!/usr/bin/env bash

set -e

# Colors for output
green='\033[0;32m'
yellow='\033[1;33m'
reset='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$DOTFILES_DIR/backup_$(date +%Y%m%d_%H%M%S)"

# List of configs to symlink: (source, target)
declare -A DOTS=(
  ["$DOTFILES_DIR/config/nvim"]="$HOME/.config/nvim"
  ["$DOTFILES_DIR/config/tmux"]="$HOME/.config/tmux"
  ["$DOTFILES_DIR/config/alacritty"]="$HOME/.config/alacritty"
  ["$DOTFILES_DIR/config/yazi"]="$HOME/.config/yazi"
)

# Zsh config
ZSHRC_SRC="$DOTFILES_DIR/config/zsh/.zshrc"
ZSHRC_TARGET="$HOME/.zshrc"

# Function to backup and symlink
do_link() {
  src="$1"
  target="$2"
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo -e "${yellow}Backing up $target to $BACKUP_DIR${reset}"
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/" || true
  fi
  ln -sfn "$src" "$target"
  echo -e "${green}Linked $src -> $target${reset}"
}

echo -e "${green}==> Symlinking config directories...${reset}"
for src in "${!DOTS[@]}"; do
  do_link "$src" "${DOTS[$src]}"
done

# Zsh config
if [ -f "$ZSHRC_SRC" ]; then
  do_link "$ZSHRC_SRC" "$ZSHRC_TARGET"
fi

# Install Homebrew (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo -e "${yellow}Homebrew not found. Installing Homebrew...${reset}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$($(brew --prefix)/bin/brew shellenv)"
  else
    echo -e "${green}Homebrew already installed.${reset}"
  fi
fi

# Helper to install a Homebrew package if not present
brew_install() {
  pkg="$1"
  if ! brew list --formula | grep -q "^$pkg$"; then
    echo -e "${yellow}Installing $pkg...${reset}"
    brew install "$pkg"
  else
    echo -e "${green}$pkg already installed.${reset}"
  fi
}

# Helper to install a Homebrew cask if not present
brew_cask_install() {
  cask="$1"
  if ! brew list --cask | grep -q "^$cask$"; then
    echo -e "${yellow}Installing $cask...${reset}"
    brew install --cask "$cask"
  else
    echo -e "${green}$cask already installed.${reset}"
  fi
}

# Install core tools and fonts (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew_install neovim
  brew_install tmux
  brew_cask_install alacritty
  brew_cask_install iterm2  # Add iTerm2 terminal
  brew_install yazi
  brew_install fzf
  brew_install ripgrep
  brew_install bat
  brew_install fd
  # Install Nerd Fonts for Alacritty and iTerm2
  brew tap homebrew/cask-fonts
  brew_cask_install font-meslo-lg-nerd-font
fi

# Install LazyGit (if not present)
if ! command -v lazygit >/dev/null 2>&1; then
  echo -e "${yellow}Installing LazyGit...${reset}"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew_install lazygit
  else
    echo -e "${yellow}Please install LazyGit manually for your OS.${reset}"
  fi
else
  echo -e "${green}LazyGit already installed.${reset}"
fi

# Install Tmux plugins automatically using TPM
TMUX_TPM="$HOME/.config/tmux/plugins/tpm"
if [ -d "$TMUX_TPM" ]; then
  echo -e "${green}==> Installing Tmux plugins with TPM...${reset}"
  bash "$TMUX_TPM/bin/install_plugins"
else
  echo -e "${yellow}TPM not found at $TMUX_TPM. Please ensure TPM is cloned for Tmux plugin management.${reset}"
fi

# Optionally, pre-install Neovim plugins (headless)
if command -v nvim >/dev/null 2>&1; then
  echo -e "${green}==> Installing Neovim plugins (headless)...${reset}"
  nvim --headless "+Lazy! sync" +qa || true
else
  echo -e "${yellow}Neovim not found, skipping Neovim plugin installation.${reset}"
fi

echo -e "${green}All done! Please restart your terminal or source your shell config.${reset}" 