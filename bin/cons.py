#! /usr/bin/env python
# -*- coding:utf-8 -*-

import sys

cons_list = []
for _ in range(1, int(sys.argv[1])):
    cons_list.append(sys.argv[2])
print ' '.join(cons_list)
