#! /usr/bin/env python
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
    '.gitmessage.txt',
    '.pylintrc',
    '.globalrc',
    '.ctags',
    '.peco',
    '.boxes',
    '.aspell.conf',
    '.dircolors',
]
for dotfile in dotfiles_list:
    system('ln -sf ~/dotfiles/{} ~/.'.format(dotfile))

platform = platform.system()
if platform == 'Darwin':
    system('ln -sf ~/dotfiles/.screenrc_mac ~/.screenrc')
    system('ln -sf ~/dotfiles/.screeninator_mac ~/.screeninator')
    system('ln -sf ~/dotfiles/.swiftlint.yml ~/.')
elif platform == 'Linux':
    system('ln -sf ~/dotfiles/.screenrc_linux ~/.screenrc')
    system('ln -sf ~/dotfiles/.screeninator_linux ~/.screeninator')

system('touch $HOME/.screen-exchange')
