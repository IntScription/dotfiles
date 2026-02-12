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
   git clone https://github.com/IntScription/dotfiles.git
   cd dotfiles
   ```

3. **Run the install script:**

   ```sh
   chmod +x install.sh
   ./install.sh
   ```

This will:

- Install all essential tools: Neovim, Tmux, Alacritty, Yazi, fzf, ripgrep,
  bat, fd, LazyGit, and iTerm2
- Install Nerd Fonts for beautiful terminal glyphs
- Symlink all your configuration files (backing up any existing ones)
- Automatically install Tmux plugins and Neovim plugins
- Clone and bootstrap my Devlog (Jekyll) site at
  `~/projects/learning/devlog`
- Give you clear feedback at every step

After the script completes, restart your terminal or source your shell config:

```sh
source ~/.zshrc
```

---

## 📦 What Are Dotfiles?

Dotfiles are configuration files for Unix-based systems that help you
personalize your shell, editors, terminal, and other tools. Keeping them in a
version-controlled repository makes it easy to set up a new machine or share
your setup with others.

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
- **Devlog (Jekyll)**: Auto-clones my Devlog repo and installs Ruby gems.
  Includes a `devlog` Zsh helper to create today’s entry with Prev/Next
  navigation.

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
git clone https://github.com/IntScription/dotfiles.git
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

## 📓 Devlog (Jekyll)

- The installer clones `https://github.com/IntScription/devlog` to
  `~/projects/learning/devlog` and runs `bundle install`.
- Repo: [IntScription/devlog](https://github.com/IntScription/devlog)

### Local preview

```sh
cd ~/projects/learning/devlog
bundle exec jekyll serve
```

Then open `http://localhost:4000/devlog/`.

### Daily logging helper

After reloading your shell:

```sh
source ~/.zshrc
devlog
```

This opens today’s `logs/YYYY-MM-DD/index.md` in Neovim and auto-updates
Prev/Next links for today and the previous entry. It also refreshes the archive
and the homepage’s recent entries.

### Notes (optional)

Place Markdown notes under `~/projects/learning/devlog/notes/`, or symlink an
Obsidian folder:

```sh
ln -s ~/Obsidian/Vault/MyNotes ~/projects/learning/devlog/notes/MyNotes
```

---

## ✅ Auto-fix Markdown on Save (LazyVim)

- A fixer script lives at `scripts/fix_markdown.sh` and a config at
  `.markdownlint.json`.
- Neovim is configured to run the fixer automatically on save for Markdown
  files in this repo.
- You can also run it manually:

```sh
/Users/kartiksanil/dotfiles/scripts/fix_markdown.sh
```

Or with the alias:

```sh
fixmd
```

The fixer prefers `markdownlint-cli2` if installed, falling back to
`markdownlint` (markdownlint-cli). The installer sets up both on macOS.

Preview Markdown in-browser with `iamcco/markdown-preview.nvim`:

```sh
:MarkdownPreviewToggle
```

Keymap: `<leader>mp`.

## 🍺 Homebrew Installation (macOS)

If you don't have Homebrew, the `install.sh` script will install it for you.
Homebrew is the recommended package manager for macOS and is used to install
tools like LazyGit.

---

## 🔧 Troubleshooting

- **Tmux using default config**: Tmux 3.1+ reads `~/.config/tmux/tmux.conf`. This
  repo uses `config/tmux/tmux.conf`. If you get “No such file or directory” when
  sourcing, (re)create the symlinks from the repo root:
  `ln -sfn "$(pwd)/config/tmux" "$HOME/.config/tmux"` and
  `ln -sfn "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"`. Then run
  `tmux source-file ~/.config/tmux/tmux.conf` or restart tmux.
- **Neovim closes on H or yank with “kill” in terminal**: If pressing H (e.g. in
  neo-tree to toggle hidden) or yanking closes nvim and the terminal shows “kill”,
  check what’s mapped: in nvim run `:verbose map H` and `:verbose map y`. Test
  without plugins: `nvim -u NONE` and try H/y again. In iTerm2, check Keys →
  Key Mappings for anything bound to H or y that might send a control character.

---

## 🔗 How the Symlinking Works

- Existing configs are backed up to a `backup_YYYYMMDD_HHMMSS` folder in the
  repo.
- New configs are symlinked from the repo to your `~/.config` directory (and
  `~/.zshrc`).
- This makes it easy to update configs by just pulling changes and re-running
  the script.

---

## 🛠️ Customization & Forking

Feel free to fork this repo and adapt it to your needs! You can:

- Add your own plugins, themes, or scripts
- Modify configs for your workflow
- Share improvements via pull requests

---

## 🤝 Contributing

Contributions, suggestions, and issues are welcome! Please open an issue or PR
if you have ideas to improve these dotfiles.

---

## 📄 License

MIT License.

---

## 💡 Why Use This Setup?

- **Fast onboarding:** Get your dev environment up and running in minutes.
- **Consistency:** Same setup across all your machines.
- **Easy to update:** Just pull and re-run the script.

---

Happy coding! 🚀
