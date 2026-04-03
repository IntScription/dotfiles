# ============================================================
#                     ZSH CONFIGURATION
# ============================================================
# Clean setup with:
# - Powerlevel10k
# - Autosuggestions + syntax highlighting
# - FZF + fd + bat previews
# - zoxide navigation
# - yazi integration
# - custom colored table ls/la
# - improved completion behavior
# - command timing
# - history cleanup + performance-oriented shell options
# ============================================================


# ============================================================
# 1) THEME: POWERLEVEL10K
# ============================================================
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# ============================================================
# 2) QUICK COMMANDS / SHORTCUT ALIASES
# ============================================================
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"
alias fixmd="$HOME/dotfiles/scripts/fix_markdown.sh"
alias cls="clear"


# ============================================================
# 3) HISTORY SETTINGS
# ============================================================
# Standardize on one history file:
# Use ~/.zsh_history and stop using ~/.zhistory going forward.
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_expire_dups_first
setopt hist_verify
setopt extendedhistory
setopt inc_append_history

# Optional one-time migration helper:
# Run `migrate-zsh-history` once if you want to merge ~/.zhistory into ~/.zsh_history
migrate-zsh-history() {
  local old_hist="$HOME/.zhistory"
  local new_hist="$HOME/.zsh_history"

  [[ -f "$old_hist" ]] || { echo "No ~/.zhistory found."; return 0; }
  touch "$new_hist"

  cat "$old_hist" >> "$new_hist"
  awk '!seen[$0]++' "$new_hist" > "${new_hist}.tmp" && mv "${new_hist}.tmp" "$new_hist"

  echo "Merged ~/.zhistory into ~/.zsh_history"
  echo "You can inspect and delete ~/.zhistory manually if everything looks fine."
}


# ============================================================
# 4) PERFORMANCE / SHELL BEHAVIOR
# ============================================================
# Show timing for commands that take longer than 3 seconds
REPORTTIME=3

# Faster, cleaner shell behavior
setopt auto_cd
setopt no_beep
setopt interactive_comments
setopt complete_in_word
setopt always_to_end

# Better directory navigation behavior
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus


# ============================================================
# 5) KEY BINDINGS
# ============================================================
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward


# ============================================================
# 6) ZSH PLUGINS
# ============================================================
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


# ============================================================
# 7) DEFAULT EDITOR
# ============================================================
export EDITOR="nvim"


# ============================================================
# 8) NODE / NVM
# ============================================================
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"


# ============================================================
# 9) RUBY / RBENV
# ============================================================
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"


# ============================================================
# 10) PERL LOCAL INSTALL
# ============================================================
export PATH="$HOME/perl5/bin:$PATH"
export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5:$PERL_LOCAL_LIB_ROOT"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"


# ============================================================
# 11) JAVA / OPENJDK
# ============================================================
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@21/include"


# ============================================================
# 12) RUSTUP
# ============================================================
export PATH="$(brew --prefix rustup)/bin:$PATH"


# ============================================================
# 13) SPICETIFY
# ============================================================
export PATH="$PATH:$HOME/.spicetify"


# ============================================================
# 14) BAT THEME
# ============================================================
export BAT_THEME="tokyonight_night"


# ============================================================
# 15) COMPLETION SYSTEM
# ============================================================
# Enhanced completion behavior:
# - case-insensitive matching
# - better menu selection
# - colored completion lists
# - more natural matching behavior
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' completions 1
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.zsh/.zcompcache"

# Docker CLI completions path
fpath=("$HOME/.docker/completions" $fpath)

autoload -Uz compinit
compinit -d "$HOME/.zcompdump"


# ============================================================
# 16) FZF SETUP
# ============================================================
eval "$(fzf --zsh)"

[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh

export FZF_DEFAULT_OPTS="
  --color=fg:#CBE0F0,bg:#011628,hl:#B388FF
  --color=fg+:#CBE0F0,bg+:#143652,hl+:#B388FF
  --color=info:#06BCE4,prompt:#2CF9ED,pointer:#2CF9ED,marker:#2CF9ED,spinner:#2CF9ED,header:#2CF9ED
"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

preview_cmd='if [ -d {} ]; then eza --tree --icons --color=always {} | head -200; else bat --style=numbers,changes --color=always --line-range :500 {}; fi'

export FZF_CTRL_T_OPTS="--preview '$preview_cmd'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)
      fzf --preview 'eza --tree --icons --color=always {} | head -200' "$@"
      ;;
    export|unset)
      fzf --preview "eval 'echo \${}'" "$@"
      ;;
    ssh)
      fzf --preview 'dig {}' "$@"
      ;;
    *)
      fzf --preview "$preview_cmd" "$@"
      ;;
  esac
}


# ============================================================
# 17) CUSTOM TABLE LS / LA
# ============================================================
lstable() {
  local show_all=0
  local target="."

  if [[ "$1" == "-a" ]]; then
    show_all=1
    shift
  fi

  if [[ -n "$1" ]]; then
    target="$1"
  fi

  python3 - "$show_all" "$target" <<'PY'
import os
import sys
import stat
import re
import unicodedata
from datetime import datetime

show_all = sys.argv[1] == "1"
target = os.path.expanduser(sys.argv[2])

RESET = "\033[0m"
BOLD = "\033[1m"
DIM = "\033[2m"

C_HEADER = "\033[38;5;111m"
C_BORDER = "\033[38;5;60m"
C_DIR = "\033[38;5;81m"
C_FILE = "\033[38;5;252m"
C_EXEC = "\033[38;5;114m"
C_LINK = "\033[38;5;221m"
C_HIDDEN = "\033[38;5;244m"
C_PERM = "\033[38;5;109m"
C_SIZE = "\033[38;5;180m"
C_DATE = "\033[38;5;146m"
C_ICON = "\033[38;5;117m"

ANSI_RE = re.compile(r"\x1b\[[0-9;]*m")

def strip_ansi(s):
    return ANSI_RE.sub("", s)

def visual_len(s):
    plain = strip_ansi(s)
    total = 0
    for ch in plain:
        if unicodedata.combining(ch):
            continue
        ea = unicodedata.east_asian_width(ch)
        total += 2 if ea in ("W", "F") else 1
    return total

def pad_right(s, width):
    return s + " " * max(0, width - visual_len(s))

def pad_left(s, width):
    return " " * max(0, width - visual_len(s)) + s

def human_size(size):
    units = ["B", "KB", "MB", "GB", "TB"]
    s = float(size)
    for unit in units:
        if s < 1024 or unit == units[-1]:
            if unit == "B":
                return f"{int(s)}B"
            if s >= 100:
                return f"{s:.0f}{unit}"
            if s >= 10:
                return f"{s:.1f}{unit}"
            return f"{s:.2f}{unit}"
        s /= 1024

def perms(mode):
    return stat.filemode(mode)

def file_kind(entry):
    try:
        if entry.is_symlink():
            return "LINK"
        if entry.is_dir(follow_symlinks=False):
            return "DIR"
        if entry.is_file(follow_symlinks=False):
            return "FILE"
        return "OTHER"
    except Exception:
        return "UNKNOWN"

def icon_and_color(kind, name, mode):
    is_hidden = name.startswith(".")
    if kind == "DIR":
        return "󰉋", C_HIDDEN if is_hidden else C_DIR
    if kind == "LINK":
        return "󰌹", C_LINK
    if kind == "FILE":
        if mode & stat.S_IXUSR:
            return "󰈔", C_EXEC
        return "󰈙", C_HIDDEN if is_hidden else C_FILE
    return "󰘓", C_FILE

def name_with_arrow(entry, kind, base_color):
    name = entry.name
    if kind == "LINK":
        try:
            target = os.readlink(entry.path)
            return f"{base_color}{name}{RESET} {DIM}→ {target}{RESET}"
        except Exception:
            return f"{base_color}{name}{RESET}"
    return f"{base_color}{name}{RESET}"

try:
    rows = []

    with os.scandir(target) as it:
        for entry in it:
            if not show_all and entry.name.startswith("."):
                continue

            try:
                st = entry.stat(follow_symlinks=False)
                kind = file_kind(entry)
                icon, name_color = icon_and_color(kind, entry.name, st.st_mode)

                rows.append({
                    "Type": f"{C_ICON}{icon}{RESET} {name_color}{kind}{RESET}",
                    "Permissions": f"{C_PERM}{perms(st.st_mode)}{RESET}",
                    "Size": f"{C_SIZE}{'-' if kind == 'DIR' else human_size(st.st_size)}{RESET}",
                    "Modified": f"{C_DATE}{datetime.fromtimestamp(st.st_mtime).strftime('%Y-%m-%d %H:%M')}{RESET}",
                    "Name": name_with_arrow(entry, kind, name_color),
                    "_sort_dir": 0 if kind == "DIR" else 1,
                    "_sort_name": entry.name.lower(),
                })
            except Exception:
                rows.append({
                    "Type": f"{C_ICON}󰘓{RESET} {C_FILE}UNKNOWN{RESET}",
                    "Permissions": f"{C_PERM}??????????{RESET}",
                    "Size": f"{C_SIZE}?{RESET}",
                    "Modified": f"{C_DATE}?{RESET}",
                    "Name": f"{C_FILE}{entry.name}{RESET}",
                    "_sort_dir": 2,
                    "_sort_name": entry.name.lower(),
                })

    rows.sort(key=lambda x: (x["_sort_dir"], x["_sort_name"]))

    headers = {
        "Type": f"{BOLD}{C_HEADER}Type{RESET}",
        "Permissions": f"{BOLD}{C_HEADER}Permissions{RESET}",
        "Size": f"{BOLD}{C_HEADER}Size{RESET}",
        "Modified": f"{BOLD}{C_HEADER}Modified{RESET}",
        "Name": f"{BOLD}{C_HEADER}Name{RESET}",
    }

    cols = ["Type", "Permissions", "Size", "Modified", "Name"]
    widths = {c: visual_len(strip_ansi(headers[c])) for c in cols}

    for row in rows:
        for c in cols:
            widths[c] = max(widths[c], visual_len(row[c]))

    def border(left, mid, right):
        return C_BORDER + left + mid.join("─" * (widths[c] + 2) for c in cols) + right + RESET

    def make_row(row):
        cells = []
        for c in cols:
            val = row[c]
            if c == "Size":
                cell = " " + pad_left(val, widths[c]) + " "
            else:
                cell = " " + pad_right(val, widths[c]) + " "
            cells.append(cell)
        return C_BORDER + "│" + RESET + (C_BORDER + "│" + RESET).join(cells) + C_BORDER + "│" + RESET

    print(border("┌", "┬", "┐"))
    print(make_row(headers))
    print(border("├", "┼", "┤"))

    if rows:
        for row in rows:
            print(make_row(row))
    else:
        empty = {
            "Type": "",
            "Permissions": "",
            "Size": "",
            "Modified": "",
            "Name": f"{DIM}(empty){RESET}",
        }
        print(make_row(empty))

    print(border("└", "┴", "┘"))

except FileNotFoundError:
    print(f"Path not found: {target}", file=sys.stderr)
    sys.exit(1)
except NotADirectoryError:
    print(f"Not a directory: {target}", file=sys.stderr)
    sys.exit(1)
except PermissionError:
    print(f"Permission denied: {target}", file=sys.stderr)
    sys.exit(1)
PY
}

alias ls="lstable"
alias la="lstable -a"
alias ll="lstable"
alias lla="lstable -a"
alias lt="eza --tree --level=2 --icons --group-directories-first --color=always"

# Raw eza views if needed
alias lx="eza --icons --group-directories-first --color=always"
alias lxa="eza -a --icons --group-directories-first --color=always"
alias lxl="eza -la --icons --group-directories-first --header --time-style=long-iso --color=always"


# ============================================================
# 18) DIRECTORY / PROJECT HELPERS
# ============================================================
mkcd() {
  mkdir -p "$1" && cd "$1"
}

alias proj="cd ~/Projects"
alias personal="cd ~/Projects/Personal"
alias learning="cd ~/Projects/Learning"
alias work="cd ~/Projects/Work"

alias path='echo -e ${PATH//:/\\n}'


# ============================================================
# 19) THEFUCK
# ============================================================
eval "$(thefuck --alias)"
eval "$(thefuck --alias fk)"


# ============================================================
# 20) ZOXIDE
# ============================================================
eval "$(zoxide init zsh)"
alias cd="z"


# ============================================================
# 21) MISE
# ============================================================
eval "$(mise activate zsh)"


# ============================================================
# 22) YAZI INTEGRATION
# ============================================================
function y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"

  if [ -f "$tmp" ]; then
    cwd="$(<"$tmp")"
    if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  fi
}

alias yazi-launch="y"


# ============================================================
# 23) DEVLOG HELPER
# ============================================================
devlog() {
  cd ~/projects/learning/devlog || return
  local date_today logs_dir filename prev next prev_prev i
  local logs prev_file nav_line devlog_count devlog_number new_entry recent_entries

  date_today=$(date +%Y-%m-%d)
  logs_dir="logs/$date_today"
  filename="$logs_dir/index.md"
  mkdir -p "$logs_dir"

  logs=("${(@f)$(find logs -type d -mindepth 1 -maxdepth 1 -exec basename {} \; | sort)}")

  prev=""
  next=""
  prev_prev=""

  for ((i = 0; i < ${#logs[@]}; i++)); do
    if [[ "${logs[$i]}" == "$date_today" ]]; then
      ((i > 0)) && prev="${logs[$((i-1))]}"
      ((i > 1)) && prev_prev="${logs[$((i-2))]}"
      ((i < ${#logs[@]} - 1)) && next="${logs[$((i+1))]}"
      break
    fi
  done

  if [[ ! -f "$filename" ]]; then
    cat > "$filename" <<EOF
---
layout: default
permalink: /logs/$date_today/
---

# Devlog - $date_today

## 🚀 What I Did

-

## 🧠 What I Learned

-

## 🔥 What's Next

-
<!-- NAV-START -->
$(
  nav_line=""
  if [[ -n "$prev" && -n "$next" ]]; then
    nav_line="[← Previous]({{site.baseurl}}/logs/$prev/) | [Next →]({{site.baseurl}}/logs/$next/)"
  elif [[ -n "$prev" ]]; then
    nav_line="[← Previous]({{site.baseurl}}/logs/$prev/)"
  elif [[ -n "$next" ]]; then
    nav_line="[Next →]({{site.baseurl}}/logs/$next/)"
  fi
  [[ -n "$nav_line" ]] && printf "%s\n" "---\n$nav_line"
)
<!-- NAV-END -->
EOF
  else
    if grep -q '<!-- NAV-START -->' "$filename"; then
      sed -i '' '/<!-- NAV-START -->/,/<!-- NAV-END -->/d' "$filename"
    else
      sed -i '' -E '/^[[:space:]]*\[← Previous\].*|^[[:space:]]*\[Next →\].*/d' "$filename"
    fi

    sed -i '' -E '${/^[[:space:]]*---[[:space:]]*$/d;}' "$filename"

    nav_line=""
    if [[ -n "$prev" && -n "$next" ]]; then
      nav_line="[← Previous]({{site.baseurl}}/logs/$prev/) | [Next →]({{site.baseurl}}/logs/$next/)"
    elif [[ -n "$prev" ]]; then
      nav_line="[← Previous]({{site.baseurl}}/logs/$prev/)"
    elif [[ -n "$next" ]]; then
      nav_line="[Next →]({{site.baseurl}}/logs/$next/)"
    fi

    if [[ -n "$nav_line" ]]; then
      cat >> "$filename" <<EOF

<!-- NAV-START -->
---
$nav_line
<!-- NAV-END -->
EOF
    fi
  fi

  if [[ -n "$prev" ]]; then
    prev_file="logs/$prev/index.md"
    if [[ -f "$prev_file" ]] && ! grep -q "/logs/$date_today/" "$prev_file"; then
      sed -i '' '/<div class="nav-links">/,/<\/div>/d' "$prev_file"

      if grep -q '<!-- NAV-START -->' "$prev_file"; then
        sed -i '' '/<!-- NAV-START -->/,/<!-- NAV-END -->/d' "$prev_file"
      else
        sed -i '' -E '/^[[:space:]]*\[← Previous\].*|^[[:space:]]*\[Next →\].*/d' "$prev_file"
      fi

      sed -i '' -E '${/^[[:space:]]*---[[:space:]]*$/d;}' "$prev_file"

      nav_line="[Next →]({{site.baseurl}}/logs/$date_today/)"
      [[ -n "$prev_prev" ]] && nav_line="[← Previous]({{site.baseurl}}/logs/$prev_prev/) | $nav_line"

      cat >> "$prev_file" <<EOF

<!-- NAV-START -->
---
$nav_line
<!-- NAV-END -->
EOF
    fi
  fi

  devlog_count=$(grep -o '\[.*— Devlog #[0-9]*\]' archive.md | wc -l | awk '{print $1}')
  devlog_number=$((devlog_count + 1))
  new_entry="- [$date_today — Devlog #$devlog_number]({{site.baseurl}}/logs/$date_today/)"

  if ! grep -q "$date_today" archive.md; then
    awk -v new="$new_entry" '
      BEGIN { added = 0 }
      { print }
      $0 ~ /## 📅 2025 Logs/ && !added { print new; added = 1 }
    ' archive.md > archive_tmp.md && mv archive_tmp.md archive.md
  fi

  recent_entries=$(grep '^- \[.*Devlog' archive.md | head -n 5)

  if grep -q '<!-- DEVLOG-RECENT-START -->' index.md; then
    awk -v new="$recent_entries" '
      BEGIN { inblock = 0 }
      /<!-- DEVLOG-RECENT-START -->/ { print; print new; inblock = 1; next }
      /<!-- DEVLOG-RECENT-END -->/ { print; inblock = 0; next }
      !inblock { print }
    ' index.md > index_tmp.md && mv index_tmp.md index.md
  else
    awk -v new="$recent_entries" '
      BEGIN { insection = 0 }
      /## 📅 Recent Devlog Entries/ {
        print;
        print "<!-- DEVLOG-RECENT-START -->";
        print new;
        print "<!-- DEVLOG-RECENT-END -->";
        insection = 1; next
      }
      insection && /^\[→ See Full Archive\]/ { print; insection = 0; next }
      insection && /^- \[/ { next }
      { print }
    ' index.md > index_tmp.md && mv index_tmp.md index.md
  fi

  if grep -q '<!-- NAV-START -->' "$filename"; then
    sed -i '' '/<!-- NAV-START -->/,/<!-- NAV-END -->/d' "$filename"
  else
    sed -i '' -E '/^[[:space:]]*\[← Previous\].*|^[[:space:]]*\[Next →\].*/d' "$filename"
  fi

  sed -i '' -E '${/^[[:space:]]*---[[:space:]]*$/d;}' "$filename"

  nav_line=""
  if [[ -n "$prev" && -n "$next" ]]; then
    nav_line="[← Previous]({{site.baseurl}}/logs/$prev/) | [Next →]({{site.baseurl}}/logs/$next/)"
  elif [[ -n "$prev" ]]; then
    nav_line="[← Previous]({{site.baseurl}}/logs/$prev/)"
  elif [[ -n "$next" ]]; then
    nav_line="[Next →]({{site.baseurl}}/logs/$next/)"
  fi

  if [[ -n "$nav_line" ]]; then
    cat >> "$filename" <<EOF

<!-- NAV-START -->
---
$nav_line
<!-- NAV-END -->
EOF
  fi

  nvim "$filename"
}
