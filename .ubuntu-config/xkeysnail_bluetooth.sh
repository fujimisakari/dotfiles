#sudo `which xkeysnail` ~/.xkeysnailrc.py --devices "/dev/input/event21" > /dev/null 2>&1 &
# sudo `which xkeysnail` ~/.xkeysnailrc.py --devices "/dev/input/event16" > /dev/null 2>&1 &
sudo `which xkeysnail` ~/.xkeysnailrc.py --devices "/dev/input/event17" > /dev/null 2>&1 &

sleep 1
xset r rate 200 30
