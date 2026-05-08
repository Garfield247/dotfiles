#!/bin/sh
set -eu

cd "$(dirname "$0")"

if [ -z "$(git status --porcelain)" ]; then
  echo "dotfiles clean"
  exit 0
fi

git add .
git commit -m "Update dotfiles: $(date '+%Y-%m-%d %H:%M')"
git push

