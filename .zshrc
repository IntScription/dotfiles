# ────────────────────────────────────────────────
# ░░ Powerlevel10k Prompt Setup ░░
# ────────────────────────────────────────────────

# Quiet Powerlevel10k instant prompt warning
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Instant prompt (must be near the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Powerlevel10k theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Useful aliases
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# ────────────────────────────────────────────────
# ░░ Zsh History & Key Bindings ░░
# ────────────────────────────────────────────────

HISTFILE="$HOME/.zhistory"
SAVEHIST=1000
HISTSIZE=999
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify

# History search with arrow keys
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ────────────────────────────────────────────────
# ░░ Zsh Plugins ░░
# ────────────────────────────────────────────────

source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ────────────────────────────────────────────────
# ░░ Environment Variables ░░
# ────────────────────────────────────────────────

export EDITOR="nvim"

# Node
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# Ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"

# Perl local install
export PATH="$HOME/perl5/bin:$PATH"
export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5:$PERL_LOCAL_LIB_ROOT"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

# Spicetify
export PATH="$PATH:/Users/joseanmartinez/.spicetify"

# ────────────────────────────────────────────────
# ░░ FZF Setup ░░
# ────────────────────────────────────────────────

eval "$(fzf --zsh)"
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh

# FZF Theme
export FZF_DEFAULT_OPTS="
  --color=fg:#CBE0F0,bg:#011628,hl:#B388FF
  --color=fg+:#CBE0F0,bg+:#143652,hl+:#B388FF
  --color=info:#06BCE4,prompt:#2CF9ED,pointer:#2CF9ED,marker:#2CF9ED,spinner:#2CF9ED,header:#2CF9ED
"

# Use `fd` with FZF
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
_fzf_compgen_dir() { fd --type=d --hidden --exclude .git . "$1"; }

# Preview customization
preview_cmd="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$preview_cmd'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1; shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "$preview_cmd" "$@" ;;
  esac
}

# ────────────────────────────────────────────────
# ░░ CLI Tool Enhancements ░░
# ────────────────────────────────────────────────

# Bat
export BAT_THEME=tokyonight_night

# Eza
alias ls="eza --icons=always"

# TheFuck
eval "$(thefuck --alias)"
eval "$(thefuck --alias fk)"

# Zoxide
eval "$(zoxide init zsh)"
alias cd="z"

# Mise
eval "$(mise activate zsh)"

# ────────────────────────────────────────────────
# ░░ Yazi Integration ░░
# ────────────────────────────────────────────────

function y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ────────────────────────────────────────────────
# ░░ Devlog Helper ░░
# ────────────────────────────────────────────────

devlog() {
  cd ~/projects/learning/devlog || return
  local date_today logs_dir filename prev next i

  date_today=$(date +%Y-%m-%d)
  logs_dir="logs/$date_today"
  filename="$logs_dir/index.md"
  mkdir -p "$logs_dir"

  IFS=$'\n' read -r -d '' -a logs < <(find logs -type d -mindepth 1 -maxdepth 1 -exec basename {} \; | sort && printf '\0')
  prev=""; next=""
  for ((i = 0; i < ${#logs[@]}; i++)); do
    if [[ "${logs[$i]}" == "$date_today" ]]; then
      ((i > 0)) && prev="${logs[$((i-1))]}"
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

---

$(
  nav_line=""
  if [[ -n "$prev" && -n "$next" ]]; then
    nav_line="[← Previous]({{site.baseurl}}/logs/$prev/) | [Next →]({{site.baseurl}}/logs/$next/)"
  elif [[ -n "$prev" ]]; then
    nav_line="[← Previous]({{site.baseurl}}/logs/$prev/)"
  elif [[ -n "$next" ]]; then
    nav_line="[Next →]({{site.baseurl}}/logs/$next/)"
  fi
  printf "%s\n" "$nav_line"
)
EOF
  else
    # Update existing log's navigation
    sed -i '' -E '/^\[← Previous\].*|^\[Next →\].*/d' "$filename"
    # Remove trailing --- before nav
    sed -i '' -E '/^---$/d' "$filename"
    # Add updated navigation
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

---

$nav_line
EOF
    fi
  fi

  # Update previous log nav (convert old HTML nav if present; add Markdown nav)
  if [[ -n "$prev" ]]; then
    prev_file="logs/$prev/index.md"
    if [[ -f "$prev_file" ]] && ! grep -q "/logs/$date_today/" "$prev_file"; then
      # Remove old HTML nav block
      sed -i '' '/<div class="nav-links">/,/<\/div>/d' "$prev_file"
      # Remove any existing Markdown nav lines
      sed -i '' -E '/^\[← Previous\].*|^\[Next →\].*/d' "$prev_file"
      # Append new nav
      cat >> "$prev_file" <<EOF

---

[← Previous]({{site.baseurl}}/logs/$prev/) | [Next →]({{site.baseurl}}/logs/$date_today/)
EOF
    fi
  fi

  # Archive entry
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

  # Update homepage recent entries
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

  nvim "$filename"
}
