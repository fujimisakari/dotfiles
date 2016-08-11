
function dstop() { docker stop $(docker ps -a -q); }
function drm() { docker rm $(docker ps -a -q); }
function drmi() { docker rmi $(docker images -q); }
