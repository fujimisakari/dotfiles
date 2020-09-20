#!/bin/bash

xhost +SI:localuser:root
sudo `which xkeysnail` ~/.xkeysnailrc.py > /dev/null 2>&1 &

# thinkpadの中クリックでペースト機能を無効にする
# xmodmap -e 'pointer = 1 9 3 4 5 6 7 8 2'
xinput --set-prop "TPPS/2 Elan TrackPoint" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 2
xmodmap -e "pointer = 1 25 3 4 5 6 7 8 9"

xset r rate 200 30

xrdb -merge ~/.Xresources

# `which google-ime-skk` -p 1178 > /dev/null 2>&1 &
