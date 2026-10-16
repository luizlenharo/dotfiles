#!/usr/bin/env bash
# Restore dotfiles on a fresh machine: symlink configs, copy app-managed
# snapshots, and bootstrap tmux plugins. Existing targets are moved to
# ~/.dotfiles-backup/<timestamp>/ before being replaced.
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

backup() {
    local target=$1
    if [[ -e $target || -L $target ]] && [[ "$(readlink -f "$target")" != "$(readlink -f "$2")" ]]; then
        mkdir -p "$BACKUP/$(dirname "${target#$HOME/}")"
        mv "$target" "$BACKUP/${target#$HOME/}"
        echo "backed up $target"
    fi
}

# Symlink: hand-edited configs, kept live in the repo
link() {
    local src="$DOT/$1" dst=$2
    mkdir -p "$(dirname "$dst")"
    backup "$dst" "$src"
    ln -sfn "$src" "$dst"
    echo "linked $dst"
}

# Copy: files apps rewrite themselves (a symlink would get replaced)
copy() {
    local src="$DOT/$1" dst=$2
    mkdir -p "$(dirname "$dst")"
    cmp -s "$src" "$dst" && { echo "unchanged $dst"; return; }
    backup "$dst" "$src"
    cp "$src" "$dst"
    echo "copied $dst"
}

for d in ags btop fastfetch hypr kitty matugen nvim quickshell rofi tmux waybar yazi; do
    link "$d" "$HOME/.config/$d"
done
link starship.toml         "$HOME/.config/starship.toml"
link herdr/config.toml     "$HOME/.config/herdr/config.toml"
link git/ignore            "$HOME/.config/git/ignore"
link git/gitconfig         "$HOME/.gitconfig"
link .zshrc                "$HOME/.zshrc"
link tmux                  "$HOME/.tmux"
link bin/claude-desktop-wayland "$HOME/.local/bin/claude-desktop-wayland"
link bin/discord-wrapper.sh     "$HOME/.local/bin/discord-wrapper.sh"

copy mimeapps.list             "$HOME/.config/mimeapps.list"
copy vscode/settings.json      "$HOME/.config/Code/User/settings.json"
copy applications/claude-desktop.desktop "$HOME/.local/share/applications/claude-desktop.desktop"
copy claude/CLAUDE.md          "$HOME/.claude/CLAUDE.md"
copy claude/settings.json      "$HOME/.claude/settings.json"
copy claude/agents/html-slides.md "$HOME/.claude/agents/html-slides.md"

# tmux plugins are not versioned; tpm installs the rest (prefix + I)
if [[ ! -d $DOT/tmux/plugins/tpm ]]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$DOT/tmux/plugins/tpm"
fi
"$DOT/tmux/plugins/tpm/bin/install_plugins" || echo "run prefix + I inside tmux to install plugins"

echo "done${BACKUP:+ (backups, if any, in $BACKUP)}"
