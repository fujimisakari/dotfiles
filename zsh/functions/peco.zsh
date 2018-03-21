
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history


function peco-ssh() {
    BUFFER=$(grep '^Host\s' ~/.ssh/config| awk '{for(i=2;i<=NF;i++) print "ssh " $i;}' | peco)
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-ssh


function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr


function peco-go-src () {
    local selected_dir=$(ghq list | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        selected_dir="$GOPATH/src/$selected_dir"
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-go-src


function peco-branch () {
    local branch=$(git branch -a | peco | tr -d ' ' | tr -d '*')
    if [ -n "$branch" ]; then
        if [ -n "$LBUFFER" ]; then
            local new_left="${LBUFFER%\ } $branch"
        else
            local new_left="$branch"
        fi
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
    zle clear-screen
}
zle -N peco-branch


function peco-docker-containers () {
    local container=$(docker ps | tail -n +2 | peco | cut -d" " -f1)
    if [ -n "$container" ]; then
        if [ -n "$LBUFFER" ]; then
            local new_left="${LBUFFER%\ } $container"
        else
            local new_left="$container"
        fi
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
    zle clear-screen
}
zle -N peco-docker-containers


function peco-docker-images () {
    local image=$(docker images | tail -n +2 | peco | awk -F' ' '{print $3}')
    if [ -n "$image" ]; then
        if [ -n "$LBUFFER" ]; then
            local new_left="${LBUFFER%\ } $image"
        else
            local new_left="$image"
        fi
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
    zle clear-screen
}
zle -N peco-docker-images

function peco-docker-run () {
   BUFFER=$(gdic run)
   CURSOR=$#BUFFER
   zle clear-screen
}
zle -N peco-docker-run

function peco-docker-exec () {
   BUFFER=$(gdic exec)
   CURSOR=$#BUFFER
   zle clear-screen
}
zle -N peco-docker-exec
