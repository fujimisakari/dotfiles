#!/bin/bash

dir_name=$(basename "$(pwd)")
tree -J -L 6 -a \
  -I '.git|node_modules|vendor|*_test.go|.github|Dockerfile|go.mod|go.sum|Makefile|README.md' \
  --dirsfirst | python3 ~/Dropbox/dev/go-tree-sample/go-tree-sample.py > $dir_name.yaml
mv $dir_name.yaml /Users/rfujimoto/org/work/merpay/code-tree
