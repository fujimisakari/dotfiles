#!/bin/bash

for pid in `ps -e -o pid,cmd | grep xkeysnail | grep event | awk '{ print $1 }'`; do
  sudo kill ${pid}
done;

#id=`xinput | grep "ThinkPad Compact Bluetooth Keyboard with TrackPoint" | grep keyboard | sed -e "s/.*id=\(\w*\).*/\1/"`
id=`sudo ~/.pyenv/shims/xkeysnail ~/.xkeysnailrc.py | grep "ThinkPad Compact Bluetooth Keyboard" | grep '/dev/input' | sed -e "s/.*event\(\w*\).*/\1/"`
if [ -n "${id}" ]; then
  echo "load thinkpad Bluetooth Keyboard device: /dev/input/event${id}"
  sudo `which xkeysnail` ~/.xkeysnailrc.py --devices "/dev/input/event${id}" > /dev/null 2>&1 &
  # xset r rate 170 35
  xset r rate 200 30
  xinput --set-prop "pointer:ThinkPad Compact Bluetooth Keyboard with TrackPoint" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 2
fi
