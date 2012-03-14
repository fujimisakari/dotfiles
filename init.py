#! /usr/bin/env python
# -*- coding:utf-8 -*-

import sys
import re
import  platform
from os import system

if 'desktop' in sys.argv:
    dotfiles_list = ['.zshrc', '.zshenv', '.screenrc', '.vimrc', '.boxes']
else:
    dotfiles_list = ['.zshrc', '.zshenv', '.screenrc', '.vimrc']

r = re.compile("Linux")
for dotfile in dotfiles_list:
    if r.match(platform.system()):
        if dotfile == ".screenrc":
            system("ln -sf ~/misc/dotfiles/.screenrc_linux ~/.screenrc")
        else:
            system("ln -sf ~/misc/dotfiles/" + dotfile + " ~/.")
    else:
        if dotfile == ".screenrc":
            system("ln -sf ~/misc/dotfiles/.screenrc_mac ~/.screenrc")
        else:
            system("ln -sf ~/misc/dotfiles/" + dotfile + " ~/.")
