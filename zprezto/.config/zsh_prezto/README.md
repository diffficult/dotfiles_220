setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/dev/mygit/dotfiles_220/zprezto/.config/zsh_prezto/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.config/zsh_prezto/${rcfile:t}" 
done
