#!/bin/bash

# 共通設定
dotfiles=(
    'zsh/.zshenv'
    'zsh/.zshrc'
    '.vimrc'
    '.tigrc'
    '.gitconfig'
    '.gitignore'
    '.peco'
    '.dircolors'
    '.tmux.conf'
)

for dotfile in "${dotfiles[@]}"; do
    ln -sf ~/dotfiles/"$dotfile" ~/.
done

# OS固有設定
case "$(uname)" in
    Darwin)
        ln -sf ~/dotfiles/.gitconfig.local ~/.
        ;;
    Linux)
        ln -sf ~/dotfiles/.ubuntu-config/.Xresources ~/
        ln -sf ~/dotfiles/.ubuntu-config/.xkeysnailrc.py ~/
        ;;
esac

touch "$HOME/.screen-exchange"
