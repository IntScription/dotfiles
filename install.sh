#!/usr/bin/env bash

set -euo pipefail

# Colors for output
green='\033[0;32m'
yellow='\033[1;33m'
reset='\033[0m'

if [[ "${1:-}" == "--help" ]]; then
  cat <<EOF
Usage:
  ./install.sh                 Run normal install
  DRY_RUN=1 ./install.sh       Preview stow changes (no filesystem writes)
  SETUP_DEVLOG=1 ./install.sh  Setup devlog project (Jekyll site)
EOF
  exit 0
fi

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Stow-based setup
if ! command -v stow >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    echo -e "${yellow}GNU stow not found. Installing via Homebrew...${reset}"
    brew install stow
  else
    echo -e "${yellow}GNU stow is not installed. Please install it first (e.g. 'brew install stow' on macOS). Skipping stow step.${reset}"
  fi
fi

if command -v stow >/dev/null 2>&1; then
  STOW_FLAGS="-v"
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    STOW_FLAGS="-n -v"
    echo -e "${yellow}Running stow in dry-run mode (no changes will be made).${reset}"
  fi

  echo -e "${green}==> Stowing dotfiles...${reset}"
  for pkg in zsh nvim tmux alacritty yazi; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
      echo -e "${green}→ Stowing $pkg${reset}"
      stow "${STOW_FLAGS}" -t "$HOME" -d "$DOTFILES_DIR" "$pkg"
    fi
  done
fi

# Install Homebrew and packages (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo -e "${yellow}Homebrew not found. Installing Homebrew...${reset}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Try common locations for brew shellenv
    if command -v brew >/dev/null 2>&1; then
      eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || \
      eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null || \
      eval "$($(brew --prefix)/bin/brew shellenv)"
    fi
  else
    echo -e "${green}Homebrew already installed.${reset}"
  fi

  if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo -e "${green}==> Installing Homebrew packages from Brewfile...${reset}"
    brew bundle --file="$DOTFILES_DIR/Brewfile"
  fi
fi

# Minimal Linux package installer (Debian/Ubuntu)
APT_UPDATED=0
apt_install() {
  pkg="$1"
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo -e "${green}$pkg already installed.${reset}"
  else
    echo -e "${yellow}Installing $pkg...${reset}"
    if [ "$APT_UPDATED" -eq 0 ]; then
      sudo apt-get update -y >/dev/null 2>&1 || true
      APT_UPDATED=1
    fi
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

# Core tools on Linux (apt / pacman)
if command -v apt-get >/dev/null 2>&1; then
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
[ -f "$DOTFILES_DIR/scripts/fix_markdown.sh" ] && \
  chmod +x "$DOTFILES_DIR/scripts/fix_markdown.sh"

# Setup Devlog repository (clone or update) and install Jekyll deps (opt-in)
if [[ "${SETUP_DEVLOG:-0}" == "1" ]]; then
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
fi

echo
echo -e "${green}✔ Dotfiles installed successfully.${reset}"
echo -e "${green}✔ Restart your shell or run: source ~/.zshrc${reset}"
