
# function dstop() { docker stop $(docker ps -a -q); }
# function drm() { docker rm $(docker ps -a -q); }
# function drmi() { docker rmi $(docker images -q); }
function dips() { docker ps | awk 'NR>1&&$0=$1' | xargs -n 1 docker inspect -f "{{.NetworkSettings.IPAddress }} {{.Name}}"; }

function drm_image() { docker images -qf dangling=true | xargs docker rmi }
function drm_containers() { docker ps -aqf status=exited | xargs docker rm -v }
function drm_volumes() { docker volume ls -qf dangling=true | xargs docker volume rm }
