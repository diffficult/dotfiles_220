# Prezto runcoms (active)

Home dotfiles are symlinks into this directory:

```zsh
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.config/zsh/prezto_runcoms/^README.md(.N); do
  ln -sfn "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
```

Related paths:
- Prezto install: `~/.zprezto`
- Custom modules: `~/.config/zsh/modules` (e.g. fzf-alias)
- Shared aliases: `~/.aliasrc`
- Shell functions: `~/.config/functions/`
