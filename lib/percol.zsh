function percol-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        percol --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N percol-select-history


function percol-ssh() {
    BUFFER=$(grep '^HOST\s' ~/.ssh/config| awk '{for(i=2;i<=NF;i++) print "ssh " $i;}' | percol)
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N percol-ssh


function percol-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | percol --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N percol-cdr
