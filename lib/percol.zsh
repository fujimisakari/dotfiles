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

function ssh_list() {
    BUFFER=$(grep '^HOST\s' ~/.ssh/config| awk '{for(i=2;i<=NF;i++) print "ssh " $i;}' | percol)
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N ssh_list
