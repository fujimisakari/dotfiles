#! /usr/bin/env python3
# -*- coding:utf-8 -*-

import platform
from os import system

dotfiles_list = [
    'zsh/.zshenv',
    'zsh/.zshrc',
    '.vimrc',
    '.tigrc',
    '.gitconfig',
    '.gitignore',
    '.pylintrc',
    '.globalrc',
    '.ctags',
    '.peco',
    '.boxes',
    '.aspell.conf',
    '.dircolors',
    '.tmux.conf',
]
for dotfile in dotfiles_list:
    system('ln -sf ~/dotfiles/{} ~/.'.format(dotfile))

platform = platform.system()
if platform == 'Darwin':
    system('ln -sf ~/dotfiles/.swiftlint.yml ~/.')
elif platform == 'Linux':
    system('ln -sf ~/dotfiles/.ubuntu-config/.Xresources ~/')
    system('ln -sf ~/dotfiles/.ubuntu-config/.xkeysnailrc.py ~/')

system('touch $HOME/.screen-exchange')
