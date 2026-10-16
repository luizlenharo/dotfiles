# dotfiles

## Restore

```sh
git clone git@github.com:luizlenharo/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Configs are symlinked into place; anything already there is moved to
`~/.dotfiles-backup/<timestamp>/`. Files that apps rewrite on their own
(`mimeapps.list`, VS Code and Claude settings, `.desktop` entries) are copied
instead, so re-copy them into the repo when they change.

Not versioned (public repo) — back up separately: `~/.ssh/`,
`~/.config/sunshine/credentials`, `~/.npmrc`, `~/.claude.json`,
`~/.claude/projects/*/memory/`.
