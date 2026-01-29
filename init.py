#! /usr/bin/env python3
# -*- coding:utf-8 -*-

import platform
from os import system

dotfiles_list = [
    'zsh/.zshenv',
    'zsh/.zshrc',
    '.vimrc',
    '.tigrc',
    '.gitignore',
    '.peco',
    '.dircolors',
    '.tmux.conf',
]
for dotfile in dotfiles_list:
    system('ln -sf ~/dotfiles/{} ~/.'.format(dotfile))

platform = platform.system()
if platform == 'Darwin':
    system('ln -sf ~/dotfiles/.gitconfig ~/.')
elif platform == 'Linux':
    system('ln -sf ~/dotfiles/.ubuntu-config/.Xresources ~/')
    system('ln -sf ~/dotfiles/.ubuntu-config/.xkeysnailrc.py ~/')
    system('ln -sf ~/dotfiles/.ubuntu-config/.gitignore.py ~/')

system('touch $HOME/.screen-exchange')
