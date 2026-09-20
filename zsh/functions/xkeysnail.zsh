
# Usage: xkeysnail-start [laptop|thinkpad|hhkb] [config.py]
# Optional per-keyboard configs: XKEYSNAIL_LAPTOP_CONFIG,
# XKEYSNAIL_THINKPAD_CONFIG, XKEYSNAIL_HHKB_CONFIG.
function xkeysnail-start() {
  local keyboard="${1:-thinkpad}"
  local device_name config
  local config_dir="$HOME/Dropbox/dotfiles/.ubuntu-config"

  case "$keyboard" in
    laptop)
      device_name="AT Translated Set 2 keyboard"
      config="${XKEYSNAIL_LAPTOP_CONFIG:-$config_dir/.xkeysnailrc-laptop.py}"
      ;;
    thinkpad)
      device_name="Lenovo TrackPoint Keyboard II"
      config="${XKEYSNAIL_THINKPAD_CONFIG:-$config_dir/.xkeysnailrc-thinkpad.py}"
      ;;
    hhkb)
      device_name="HHKB-Studio2 Keyboard"
      config="${XKEYSNAIL_HHKB_CONFIG:-$config_dir/.xkeysnailrc-hhkb.py}"
      ;;
    *)
      print -u2 -- "Usage: xkeysnail-start [laptop|thinkpad|hhkb] [config.py]"
      return 1
      ;;
  esac
  if (( $# > 2 )); then
    print -u2 -- "Usage: xkeysnail-start [laptop|thinkpad|hhkb] [config.py]"
    return 1
  fi
  config="${2:-$config}"
  if [[ ! -r "$config" ]]; then
    print -u2 -- "Config not readable: $config"
    return 1
  fi

  # Match the keyboard handler, excluding the TrackPoint mouse interface.
  local device
  device=$(awk -v name="$device_name" '
    BEGIN { RS=""; FS="\n" }
    {
      matched = 0
      handlers = ""
      for (i = 1; i <= NF; i++) {
        if ($i == "N: Name=\"" name "\"") matched = 1
        if ($i ~ /^H: Handlers=/) handlers = $i
      }
      if (matched && handlers ~ / kbd / && handlers !~ / mouse[0-9]+ /) {
        count = split(handlers, parts, " ")
        for (i = 1; i <= count; i++) {
          if (parts[i] ~ /^event[0-9]+$/) {
            print "/dev/input/" parts[i]
            exit
          }
        }
      }
    }
  ' /proc/bus/input/devices)
  if [[ -z "$device" || ! -e "$device" ]]; then
    print -u2 -- "Keyboard not found: $device_name"
    return 1
  fi

  local executable
  executable=$(whence -p xkeysnail) || {
    print -u2 -- "xkeysnail executable not found"
    return 1
  }
  sudo -v || return 1
  xhost +SI:localuser:root || return 1
  print -r -- "Start xkeysnail: $keyboard ($device), config: $config"
  sudo "$executable" "$config" --devices "$device" > /dev/null 2>&1 &
  xset r rate 200 20
  xmodmap -e "pointer = 1 25 3 4 5 6 7 8 9"
  xrdb -merge ~/.Xresources
}

function xkeysnail-stop() {
  PID=`ps -e -o pid,cmd | grep xkeysnail | awk '{ print $1 }' | head -n 1`
  if [ -n "$PID" ]; then
    sudo kill $PID
    echo "Stop xkeysnail to kill $PID"
  fi
}
