#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="/Users/kartiksanil/dotfiles"
ML_CONFIG="$ROOT_DIR/.markdownlint.json"

paths=("$@")
if [ ${#paths[@]} -eq 0 ]; then
  paths=("$ROOT_DIR")
fi

# Ensure markdownlint-cli exists (best-effort install on macOS)
LINTER=""
if command -v markdownlint-cli2 >/dev/null 2>&1; then
  LINTER="markdownlint-cli2"
elif command -v markdownlint >/dev/null 2>&1; then
  LINTER="markdownlint"
else
  if [[ "${OSTYPE:-}" == darwin* ]] && command -v brew >/dev/null 2>&1; then
    brew list --formula | grep -q '^markdownlint-cli2$' || brew install markdownlint-cli2 || true
    brew list --formula | grep -q '^markdownlint-cli$' || brew install markdownlint-cli || true
  fi
  if command -v markdownlint-cli2 >/dev/null 2>&1; then
    LINTER="markdownlint-cli2"
  elif command -v markdownlint >/dev/null 2>&1; then
    LINTER="markdownlint"
  fi
fi

fix_file() {
  local file="$1"
  [ -f "$file" ] || return 0
  # Run markdownlint with --fix; ignore non-fixable rule errors
  if [ -z "$LINTER" ]; then
    return 0
  fi
  if [ "$LINTER" = "markdownlint-cli2" ]; then
    # markdownlint-cli2 fixes in place when provided files/globs
    markdownlint-cli2 "${file}" || true
  else
    if [ -f "$ML_CONFIG" ]; then
      markdownlint --fix --config "$ML_CONFIG" "$file" || true
    else
      markdownlint --fix "$file" || true
    fi
  fi
}

for p in "${paths[@]}"; do
  if [ -d "$p" ]; then
    # Find all markdown files in the directory
    while IFS= read -r -d '' f; do
      fix_file "$f"
    done < <(find "$p" -type f \( -name "*.md" -o -name "*.markdown" \) -print0)
  else
    fix_file "$p"
  fi
done


