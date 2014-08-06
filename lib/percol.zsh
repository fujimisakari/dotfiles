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

function slist() {
    hosts=( ${(@)${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && <~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*} )
    host=$(echo $hosts | sed 's/ /\
/g' | percol)
    if [[ -n $host ]]; then
        ssh $host
    fi
}
