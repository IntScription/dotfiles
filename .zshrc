# ────────────────────────────────────────────────
# ░░ Powerlevel10k Prompt Setup ░░
# ────────────────────────────────────────────────

# Instant prompt (keep near top of .zshrc)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Powerlevel10k theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Prompt customization
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# ────────────────────────────────────────────────
# ░░ Zsh History & Key Bindings ░░
# ────────────────────────────────────────────────

HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify

# History search with arrow keys
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ────────────────────────────────────────────────
# ░░ Zsh Plugins ░░
# ────────────────────────────────────────────────

# Autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ────────────────────────────────────────────────
# ░░ Environment Variables ░░
# ────────────────────────────────────────────────

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="$PATH:/Users/joseanmartinez/.spicetify"
export PATH="$HOME/.rbenv/shims:$PATH"

# ────────────────────────────────────────────────
# ░░ FZF Setup ░░
# ────────────────────────────────────────────────

# Load fzf and key bindings
eval "$(fzf --zsh)"
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh

# FZF Theme Colors
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# Use fd (faster alternative to find)
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# FZF Preview Customization
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Custom FZF preview runners
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"                         "$@" ;;
    ssh)          fzf --preview 'dig {}'                                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview"               "$@" ;;
  esac
}

# ────────────────────────────────────────────────
# ░░ CLI Tool Enhancements ░░
# ────────────────────────────────────────────────

# Bat (better cat)
export BAT_THEME=tokyonight_night

# Eza (better ls)
alias ls="eza --icons=always"

# TheFuck (command correction)
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# Zoxide (better cd)
eval "$(zoxide init zsh)"
alias cd="z"

# --- Yazi Function: Launches Yazi and Returns to the Selected Directory ---
export EDITOR="nvim"
 
function y() {
	# Create a temporary file to store the new working directory
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	
	# Launch Yazi with any passed arguments, using the temp file to store the new directory path
	yazi "$@" --cwd-file="$tmp"
	
	# If the temp file contains a valid and different directory path, change to that directory
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	
	# Remove the temporary file
	rm -f -- "$tmp"
} 

eval "$(mise activate zsh)"  # or "bash" if using bash

PATH="/Users/kartiksanil/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/kartiksanil/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/kartiksanil/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/kartiksanil/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/kartiksanil/perl5"; export PERL_MM_OPT;

# Devlog shortcut
devlog() {
    cd ~/projects/learning/devlog
    date_today=$(date +%Y-%m-%d)
    logs_dir="logs/$date_today"
    filename="$logs_dir/index.md"

    # Find yesterday's log (most recent existing one)
    last_log=$(ls -d logs/*/ | sort -r | grep -v "$date_today" | head -n 1 | sed 's:logs/::; s:/::')
    logs_dir_last="logs/$last_log/index.md"

    # Create today's log folder
    mkdir -p "$logs_dir"

    # Create index.md if missing
    if [ ! -f "$filename" ]; then
        cat << EOF > "$filename"
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

<div class="nav-links">
EOF

        if [ -n "$last_log" ]; then
            echo "<a href=\"{{ site.baseurl }}/logs/$last_log/\">← Previous</a>" >> "$filename"
        fi

        echo "</div>" >> "$filename"
    fi

    # Update yesterday's log with Next → if exists
    if [ -f "$logs_dir_last" ]; then
        sed -i '' '/<div class="nav-links">/,/<\/div>/ s|</div>|<a href="{{ site.baseurl }}/logs/'"$date_today"'/">Next →</a></div>|' "$logs_dir_last"
    fi

    # Archive numbering
    devlog_count=$(grep -o '\[.*— Devlog #[0-9]*\]' archive.md | wc -l | awk '{print $1}')
    devlog_number=$((devlog_count + 1))
    new_entry="- [$date_today — Devlog #$devlog_number](/devlog/logs/$date_today/)"

    # Archive update
    if ! grep -q "$date_today" archive.md; then
        sed -i '' "4i\\
$new_entry
" archive.md
    fi

    # Update index.md with recent 5 logs
    recent_entries=$(grep '\- \[.*Devlog' archive.md | head -n 5)
    cat << EOF > index.md
---
layout: default
title: Hello Devs 📓
---

<link rel="stylesheet" href="{{ '/assets/css/style.css' | relative_url }}">

Welcome to my public developer log.  
I document my progress, projects, learning experiences, and reflections as I build and improve my skills in software engineering, AI, and development tools.

---

## 📅 Recent Devlog Entries
$recent_entries

[→ See Full Archive]({{ site.baseurl }}/archive/)

---

## 🎯 Why This Devlog Exists
I believe in **learning in public**.
This devlog helps me:
- Track my progress consistently
- Reflect on my challenges and breakthroughs
- Stay accountable to my personal and professional goals
- Share my journey with others

---

## 🔗 Connect With Me
- [GitHub](https://github.com/IntScription)
- [YouTube](https://www.youtube.com/@idkythisisme)
EOF

    nvim "$filename"
}

