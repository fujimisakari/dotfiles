#!/bin/bash
set -eu

DOTFILES_DIR="${HOME}/dotfiles"

# エラー時のメッセージ
error() {
    echo "Error: $1" >&2
    exit 1
}

# dotfilesディレクトリの存在確認
[[ -d "$DOTFILES_DIR" ]] || error "dotfiles directory not found: $DOTFILES_DIR"

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
    src="${DOTFILES_DIR}/${dotfile}"
    [[ -e "$src" ]] || { echo "Warning: $src not found, skipping"; continue; }
    ln -sf "$src" ~/. && echo "Linked: $dotfile"
done

# OS固有設定
case "$(uname)" in
    Darwin)
        src="${DOTFILES_DIR}/.gitconfig.local"
        [[ -e "$src" ]] && ln -sf "$src" ~/. && echo "Linked: .gitconfig.local"
        ;;
    Linux)
        for file in .Xresources .xkeysnailrc.py; do
            src="${DOTFILES_DIR}/.ubuntu-config/${file}"
            [[ -e "$src" ]] && ln -sf "$src" ~/. && echo "Linked: $file"
        done
        ;;
esac

touch "$HOME/.screen-exchange"

echo "Setup complete!"
