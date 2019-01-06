
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Aliase Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

case "${OSTYPE}" in
  linux*)
    alias ls='ls -vF --color=auto'
    alias ll='ls -lavFh --color'
    alias ptree='pstree -acGhlunp | more'
    alias df='df -h'
    alias open='xdg-open 2>/dev/null'
    alias -g C='| xsel --input --clipboard'
  ;;
  darwin*)
    alias ls='/usr/local/bin/gls -vF --color=auto'
    alias ll='/usr/local/bin/gls -lavFh --color'
    alias find='/usr/local/bin/gfind'
    alias ptree='pstree | lv'
    alias boxes='/usr/local/bin/boxes'
    alias ssh="ssh -A -l ${USER}"
    alias netstat='netstat -n -p tcp'
    alias -g C='| /usr/bin/pbcopy'
  ;;
esac

## SSHコマンドはscreenの新しい窓で
if [ "x${TERM}" = xscreen-bce ]; then
  function ssh_screen(){
    eval server=\${$#}
    local name="$(echo ${server} | cut -d '@' -f 2)"
    # screen -t ${name} ssh -l ${USER} "${@}"
    screen -t ${name} ssh "${@}"
  }
  alias ssh=ssh_screen
fi

alias h='history -i -D -E -40'
alias scrin="screen -S ${USER} -U -t ${HOST}"
alias scp='scp -r'
alias diff='diff -u'
alias eng='LANG=C LANGUAGE=C LC_ALL=C LC_TIME=C LC_MESSAGES=C'
alias euc='LANG=ja_JP.eucJP LANGUAGE=ja LC_ALL=ja_JP.eucJP'
alias utf='LANG=ja_JP.UTF-8 LANGUAGE=ja LC_ALL=ja_JP.UTF-8'
alias less='/usr/share/vim/vim[0-9]*/macros/less.sh'
alias dl='find . -type d | xargs du -hs'

alias dstop='gdic stop'
alias drm='gdic rm'
alias drmi='gdic rmi'

## global aliase
alias -g L='| lv'
alias -g G='| grep'
alias -g M='| more'
alias -g W='| wc'
alias -g S='| sort'
alias -g U='| uniq'
alias -g A='| awk'
alias -g H='| head'
alias -g LE='| less'
alias -g SE='| sed'
alias -g XA='| xargs'
