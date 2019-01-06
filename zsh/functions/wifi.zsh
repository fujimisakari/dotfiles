
function wifi-list() {
  nmcli device wifi list
}

function wifi-status() {
  nmcli device status
}

function wifi-connect() {
  local ssid=${1}
  local password=${2}
  local interface=${3}
  nmcli device wifi connect ${ssid} password ${password} ifname ${interface}
}

function wifi-disconnect() {
  local interface=${1}
  nmcli dev disconnect ${interface}
}

function wifi-delete() {
  local ssid=${1}
  nmcli dev disconnect ${ssid}
}
