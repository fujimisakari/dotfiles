
##------------------------------------------------------------------##
#                         Emacs固有設定                              #
##------------------------------------------------------------------##

# キーバインド設定
alias emac='/usr/bin/emacsclient -n'

# インクリメンタル補完はanythingを使う
anything-history ()  {
    tmpfile=/tmp/.azh-tmp-file
    emacsclient --eval '(anything-zsh-history-from-zle)' > /dev/null
    zle -U "`cat $tmpfile`"
    rm -f $tmpfile
}
zle -N anything-history
bindkey "^R" anything-history

