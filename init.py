#! /usr/bin/env python
# -*- coding:utf-8 -*-

import re
import platform
from os import system

# if 'desktop' in sys.argv:
#     dotfiles_list = ['.zshrc', '.zshenv', '.screenrc', '.vimrc', '.boxes', '.gitconfig', '.gitignore', '.aspell.conf', '.globalrc']
# else:
#     dotfiles_list = ['.zshrc', '.zshenv', '.screenrc', '.vimrc', '.tigrc']
DOTFILES_LIST = ['.screenrc', '.vimrc', '.screeninator', '.boxes', '.gitconfig', '.gitignore',
                 '.aspell.conf', '.tigrc', '.globalrc', '.offlineimaprc', '.percol.d', '.ctags', '.my.cnf', '.gitmessage.txt',
                 '.swiftlint.yml']

REGEXP = re.compile("Linux")

for dotfile in DOTFILES_LIST:
    if REGEXP.match(platform.system()):
        if dotfile == '.screenrc':
            system('ln -sf ~/dotfiles/.screenrc_linux ~/.screenrc')
        else:
            system('ln -sf ~/dotfiles/' + dotfile + ' ~/.')
    else:
        if dotfile == '.screenrc':
            system('ln -sf ~/dotfiles/.screenrc_mac ~/.screenrc')
        else:
            system('ln -sf ~/dotfiles/' + dotfile + ' ~/.')


system('ln -sf ~/dotfiles/zsh/.zshenv ~/.')
system('ln -sf ~/dotfiles/zsh/.zshrc ~/.')
