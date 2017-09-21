
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Aliase Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

case "${OSTYPE}" in
  linux*)
    alias ls='ls -vF --color=auto'
    alias ll='ls -lavFh --color'
    alias psa='ps auxwwf | lv'
    alias w3m='/usr/bin/w3m -B'
    alias ptree='pstree -acGhlunp | more'
    alias df='df -h'
    alias netstat='netstat -antul'
    alias open='eog'
    alias -g C='| xsel --input --clipboard'
  ;;
  darwin*)
    alias ls='/usr/local/bin/gls -vF --color=auto'
    alias ll='/usr/local/bin/gls -lavFh --color'
    alias find='/usr/local/bin/gfind'
    alias w3m='/usr/local/bin/w3m -B'
    alias ptree='pstree | lv'
    alias updatemacdb='sudo /usr/libexec/locate.updatedb'
    alias -g C='| /usr/bin/pbcopy'
    alias boxes='/usr/local/bin/boxes'
    alias finder='open .'
    alias ssh='ssh -A -l $USER'
    alias netstat='netstat -n -p tcp'
    alias ql='qlmanage -p "$@" >& /dev/null'
    alias updatesb='find . -name "*.storyboard" -or -name "*.xib"  | xargs -IFILE xcrun ibtool --upgrade FILE --write FILE'
  ;;
esac

alias h='history -i -D -E -40'
alias pss='ps -aef | lv'
alias scrin='screen -S $USER -U -t $HOST'
alias scp='scp -r'
alias diff='diff -u'
alias df='df -h'
alias du='du -h'
alias p='pwd'
alias eng='LANG=C LANGUAGE=C LC_ALL=C LC_TIME=C LC_MESSAGES=C'
alias euc='LANG=ja_JP.eucJP LANGUAGE=ja LC_ALL=ja_JP.eucJP'
alias utf='LANG=ja_JP.UTF-8 LANGUAGE=ja LC_ALL=ja_JP.UTF-8'
alias cpan='perl -MCPAN -e shell'
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

## fool ploof
#alias cp='/usr/local/bin/gcp -i'
#alias mv='mv -i'
#alias rm='rm -i'
