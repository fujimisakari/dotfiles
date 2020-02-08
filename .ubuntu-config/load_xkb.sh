#!/bin/bash

if [ -s "${HOME}/.xkb/keymap/mykbd" ]; then
  id=`xinput | grep "ThinkPad Compact Bluetooth Keyboard with TrackPoint" | grep keyboard | sed -e "s/.*id=\(\w*\).*/\1/"`
  echo ${id}

  if [ -n "${id}" ]; then
    echo "load thinkpad Bluetooth Keyboard device: ${id}"
    xkbcomp -i ${id} -I${HOME}/.xkb ${HOME}/.xkb/keymap/mykbd ${DISPLAY}
    xinput --set-prop "pointer:ThinkPad Compact Bluetooth Keyboard with TrackPoint" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 2
    xset r rate 150 35
  fi
fi
