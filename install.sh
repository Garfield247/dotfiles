#!/bin/sh
set -eu

DOTFILES="${HOME}/dotfiles"
BACKUP="${HOME}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

backup_path() {
  path="$1"
  if [ -L "$path" ]; then
    return 0
  fi
  if [ -e "$path" ]; then
    mkdir -p "$BACKUP"
    mv "$path" "$BACKUP/"
  fi
}

link_path() {
  source="$1"
  target="$2"
  parent="$(dirname "$target")"

  mkdir -p "$parent"
  backup_path "$target"

  if [ -L "$target" ]; then
    rm "$target"
  fi

  ln -s "$source" "$target"
}

link_path "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_path "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link_path "$DOTFILES/zsh/.zimrc" "$HOME/.zimrc"
link_path "$DOTFILES/zsh/.mbprc" "$HOME/.mbprc"
link_path "$DOTFILES/kitty" "$HOME/.config/kitty"
link_path "$DOTFILES/yazi" "$HOME/.config/yazi"

echo "dotfiles linked"
if [ -d "$BACKUP" ]; then
  echo "backup: $BACKUP"
fi

