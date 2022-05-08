
function xkeysnail-start() {
  echo "Start xkeysnail"
  xhost +SI:localuser:root
  sudo `which xkeysnail` ~/.xkeysnailrc.py  > /dev/null 2>&1 &
  xset r rate 200 20
  xrdb -merge ~/.Xresources
}

function xkeysnail-stop() {
  PID=`ps -e -o pid,cmd | grep xkeysnail | awk '{ print $1 }' | head -n 1`
  if [ -n "$PID" ]; then
    sudo kill $PID
    echo "Stop xkeysnail to kill $PID"
  fi
}
