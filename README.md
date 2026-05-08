# dotfiles

Managed local configuration for:

- tmux
- zsh
- kitty
- yazi

Install symlinks:

```sh
~/dotfiles/install.sh
```

The installer moves existing files/directories into:

```text
~/.dotfiles-backup-YYYYMMDD-HHMMSS/
```

Then it creates symlinks from the normal config locations back to this repo.

