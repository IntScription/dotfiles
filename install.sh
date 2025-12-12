#!/usr/bin/env bash

set -euo pipefail

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

# Minimal Linux package installer (Debian/Ubuntu)
apt_install() {
  pkg="$1"
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo -e "${green}$pkg already installed.${reset}"
  else
    echo -e "${yellow}Installing $pkg...${reset}"
    sudo apt-get update -y >/dev/null 2>&1 || true
    sudo apt-get install -y "$pkg"
  fi
}

# Minimal Arch package installer
pac_install() {
  pkg="$1"
  if pacman -Qi "$pkg" >/dev/null 2>&1; then
    echo -e "${green}$pkg already installed.${reset}"
  else
    echo -e "${yellow}Installing $pkg...${reset}"
    sudo pacman -Sy --noconfirm "$pkg"
  fi
}

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
  brew_cask_install iterm2 # Add iTerm2 terminal
  brew_install yazi
  brew_install fzf
  brew_install ripgrep
  brew_install bat
  brew_install fd
  brew_install ruby
  brew_install markdownlint-cli
  brew_install markdownlint-cli2
  brew_install eza
  brew_install zoxide
  brew_install thefuck
  brew_install node
  # Install Nerd Fonts for Alacritty and iTerm2
  brew tap homebrew/cask-fonts >/dev/null 2>&1 || true
  brew_cask_install font-meslo-lg-nerd-font
elif command -v apt-get >/dev/null 2>&1; then
  apt_install neovim
  apt_install tmux
  apt_install fzf
  apt_install ripgrep
  apt_install bat
  apt_install fd-find
  apt_install git
  # markdownlint-cli2 via npm if desired; leave to user on Linux
elif command -v pacman >/dev/null 2>&1; then
  pac_install neovim
  pac_install tmux
  pac_install fzf
  pac_install ripgrep
  pac_install bat
  pac_install fd
  pac_install git
  pac_install yazi
  pac_install eza
  pac_install zoxide
  pac_install thefuck
  pac_install nodejs
  pac_install npm
fi

# Install LazyGit (if not present)
if ! command -v lazygit >/dev/null 2>&1; then
  echo -e "${yellow}Installing LazyGit...${reset}"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew_install lazygit
  elif command -v pacman >/dev/null 2>&1; then
    pac_install lazygit
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
  echo -e "${yellow}TPM not found at $TMUX_TPM. Cloning TPM...${reset}"
  git clone https://github.com/tmux-plugins/tpm "$TMUX_TPM" && bash "$TMUX_TPM/bin/install_plugins" ||
    echo -e "${yellow}Could not clone TPM (check git/network). Skipping TPM install.${reset}"
fi

# Optionally, pre-install Neovim plugins (headless)
if command -v nvim >/dev/null 2>&1; then
  echo -e "${green}==> Installing Neovim plugins (headless)...${reset}"
  nvim --headless "+Lazy! sync" +qa || true
else
  echo -e "${yellow}Neovim not found, skipping Neovim plugin installation.${reset}"
fi

# Ensure scripts are executable
chmod +x "$DOTFILES_DIR/scripts/fix_markdown.sh" 2>/dev/null || true

# Setup Devlog repository (clone or update) and install Jekyll deps
DEVLOG_REPO_URL="https://github.com/IntScription/devlog.git"
DEVLOG_DIR="$HOME/projects/learning/devlog"
DEVLOG_PARENT_DIR="$(dirname "$DEVLOG_DIR")"

echo -e "${green}==> Setting up Devlog at $DEVLOG_DIR...${reset}"
mkdir -p "$DEVLOG_PARENT_DIR"
if [ -d "$DEVLOG_DIR/.git" ]; then
  echo -e "${green}Devlog repo exists. Pulling latest changes...${reset}"
  git -C "$DEVLOG_DIR" pull --rebase --autostash || git -C "$DEVLOG_DIR" pull --rebase || true
elif [ -d "$DEVLOG_DIR" ]; then
  echo -e "${yellow}$DEVLOG_DIR exists but is not a git repo. Skipping clone.${reset}"
else
  echo -e "${green}Cloning Devlog repo...${reset}"
  git clone "$DEVLOG_REPO_URL" "$DEVLOG_DIR"
fi

if [ -d "$DEVLOG_DIR" ]; then
  # Ensure bundler is available, then install gems
  if ! command -v bundle >/dev/null 2>&1; then
    if command -v gem >/dev/null 2>&1; then
      echo -e "${yellow}Bundler not found. Installing bundler gem...${reset}"
      gem install bundler || true
    else
      echo -e "${yellow}RubyGems not available. Please ensure Ruby is installed if you plan to serve the site locally.${reset}"
    fi
  fi
  if command -v bundle >/dev/null 2>&1; then
    echo -e "${green}==> Installing Devlog Ruby gems (bundle install)...${reset}"
    (cd "$DEVLOG_DIR" && bundle install) || true
  fi
  echo -e "${green}Devlog ready. To serve locally: cd \"$DEVLOG_DIR\" && bundle exec jekyll serve${reset}"
fi

echo -e "${green}All done! Please restart your terminal or source your shell config.${reset}"

