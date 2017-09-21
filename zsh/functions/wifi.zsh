
function wifi-list() {
    nmcli device wifi list
}

function wifi-status() {
    nmcli device status
}

function wifi-connect() {
    ssid=$1
    password=$2
    interface=$3
    nmcli device wifi connect ${ssid} password ${password} ifname ${interface}
}

function wifi-disconnect() {
    interface=$1
    nmcli dev disconnect ${interface}
}

function wifi-delete() {
    ssid=$1
    nmcli dev disconnect ${ssid}
}
