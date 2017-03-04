
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history


function peco-ssh() {
    BUFFER=$(grep '^HOST\s' ~/.ssh/config| awk '{for(i=2;i<=NF;i++) print "ssh " $i;}' | peco)
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
