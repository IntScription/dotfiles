# Dotfiles

---

## 🚀 Quick Start on a New Mac

To set up your full development environment on a fresh macOS machine:

1. **Install Xcode Command Line Tools (if prompted):**
   ```sh
   xcode-select --install
   ```
   This is required for Homebrew and many developer tools.

2. **Clone this repository:**
   ```sh
   git clone https://github.com/yourusername/dotfiles.git
   cd dotfiles
   ```

3. **Run the install script:**
   ```sh
   chmod +x install.sh
   ./install.sh
   ```

This will:
- Install all essential tools: Neovim, Tmux, Alacritty, Yazi, fzf, ripgrep, bat, fd, LazyGit, and iTerm2
- Install Nerd Fonts for beautiful terminal glyphs
- Symlink all your configuration files (backing up any existing ones)
- Automatically install Tmux plugins and Neovim plugins
- Give you clear feedback at every step

After the script completes, restart your terminal or source your shell config:
```sh
source ~/.zshrc
```

---

## 📦 What Are Dotfiles?
Dotfiles are configuration files for Unix-based systems that help you personalize your shell, editors, terminal, and other tools. Keeping them in a version-controlled repository makes it easy to set up a new machine or share your setup with others.

---

## 🛠️ Tools & Features
This repository includes custom configurations for:

- **Zsh**: My preferred shell, with custom prompts, aliases, and plugins.
- **Neovim**: A powerful text editor setup with plugins and custom key mappings.
- **Tmux**: Terminal multiplexer for managing multiple terminal sessions.
- **Alacritty**: Fast, GPU-accelerated terminal emulator.
- **Yazi**: Blazing-fast terminal file manager.
- **LazyGit**: Terminal UI for Git, simplifying Git operations.
- **System Configurations**: Other essential config files for macOS/Linux optimization.

---

## 📁 Folder Structure
```sh
.
├── config
│   ├── alacritty
│   ├── backup
│   ├── nvim
│   ├── tmux
│   └── yazi
├── coolnight.itermcolors
├── package-lock.json
├── README.md
└── install.sh
```

---

## 🚀 Quick Installation

### 1. Prerequisites
- **macOS** (or Linux)
- [Homebrew](https://brew.sh/) (for macOS, see below)
- [Git](https://git-scm.com/)

### 2. Clone the Repository
```sh
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

### 3. Run the Setup Script
This will:
- Backup any existing configs to a timestamped backup folder
- Symlink the new configs to your home directory
- Install Homebrew (if not present, macOS only)
- Install LazyGit (if not present)

```sh
chmod +x install.sh
./install.sh
```

### 4. Restart Your Terminal
After installation, restart your terminal or source your shell config:
```sh
source ~/.zshrc
```

---

## 🍺 Homebrew Installation (macOS)
If you don't have Homebrew, the `install.sh` script will install it for you. Homebrew is the recommended package manager for macOS and is used to install tools like LazyGit.

---

## 🔗 How the Symlinking Works
- Existing configs are backed up to a `backup_YYYYMMDD_HHMMSS` folder in the repo.
- New configs are symlinked from the repo to your `~/.config` directory (and `~/.zshrc`).
- This makes it easy to update configs by just pulling changes and re-running the script.

---

## 🛠️ Customization & Forking
Feel free to fork this repo and adapt it to your needs! You can:
- Add your own plugins, themes, or scripts
- Modify configs for your workflow
- Share improvements via pull requests

---

## 🤝 Contributing
Contributions, suggestions, and issues are welcome! Please open an issue or PR if you have ideas to improve these dotfiles.

---

## 📄 License
MIT License. See [LICENSE](LICENSE) for details.

---

## 💡 Why Use This Setup?
- **Fast onboarding:** Get your dev environment up and running in minutes.
- **Consistency:** Same setup across all your machines.
- **Easy to update:** Just pull and re-run the script.

---

Happy hacking! 🚀
