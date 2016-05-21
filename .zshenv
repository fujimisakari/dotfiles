
##------------------------------------------------------------------##
#                           開発環境PC判定                           #
##------------------------------------------------------------------##

for host_name in "fujimisakari.local" "fujimotoryou-no-MacBook-Pro.local"
do
    if [ $HOST = $host_name ]; then
        ALLOW_HOST="true"
        break
    fi
    ALLOW_HOST="false"
done


##------------------------------------------------------------------##
#                         各種設定の読み込み                         #
##------------------------------------------------------------------##

## 個人設定ファイルパス
ZSHUSERDIR=$HOME/dotfiles

## zsh補完アーカイブパス
COMPLETIONDIR=$HOME/dotfiles/completion
fpath=($fpath $COMPLETIONDIR)

## colors
if [ -f $ZSHUSERDIR/lib/colors ]; then
    source $ZSHUSERDIR/lib/colors
fi

## aliases
if [ -f $ZSHUSERDIR/lib/aliases ]; then
    source $ZSHUSERDIR/lib/aliases
fi

## functions
if [ -f $ZSHUSERDIR/lib/functions ]; then
    source $ZSHUSERDIR/lib/functions
fi

## percol
if [ -f $ZSHUSERDIR/lib/percol.zsh ]; then
    source $ZSHUSERDIR/lib/percol.zsh
fi

## emacs
#if [ $HOST = "gajumaru" ]; then
#    source $ZSHUSERDIR/lib/emacs
#fi


##------------------------------------------------------------------##
#                            環境変数設定                            #
##------------------------------------------------------------------##

# 端末元が 開発PC or emacs だった場合は screen で立ち上げる
# if [ $TERM = "eterm-color" -o $ALLOW_HOST = "true" ] && [ $TERM_PROGRAM != "Apple_Terminal" ]; then
#     if [ $TERM != "screen-bce" ]; then
#         scrin
#     fi
# fi
# if [ $TERM != "screen-bce" -a $TERM != "dumb" ]; then
#     scrin
# fi

## パスの追加
case "${OSTYPE}" in
  linux*)
    PATH=$HOME/misc/bin:$HOME/.pyenv/bin:$PATH:/sbin:/usr/sbin
  ;;
  darwin*)
    PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$HOME/.pyenv/bin:/sbin:$HOME/misc/bin:$PATH
    export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
  ;;
esac

## 開発環境設定

# python設定
export PYTHONDONTWRITEBYTECODE=1  # pycは作らない

PYTHONPATH=$HOME/misc/lib:$PYTHONPATH
export PYTHONPATH

## pyenv
if [ -e "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

## google app engin
export CLOUDSDK_PYTHON=/usr/bin/python

# The next line updates PATH for the Google Cloud SDK.
source "$HOME/dev/google-cloud-platform/google-cloud-sdk/path.zsh.inc"

# The next line enables shell command completion for gcloud.
source "$HOME/dev/google-cloud-platform/google-cloud-sdk/completion.zsh.inc"

# ruby設定
if [[ -s $HOME/.rvm/scripts/rvm ]]; then
    source $HOME/.rvm/scripts/rvm  # Load RVM function
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
    # デフォルトのrubyバージョン、gemライブラリ場所を指定
    # rvm use 1.8.7
    rvm gemset use default_env > /dev/null 2>&1
fi

# node.js設定
if [[ -s ~/.nvm/nvm.sh ]];
    then source ~/.nvm/nvm.sh
fi

# common lisp設定
if [[ -s $HOME/.roswell ]]; then
    PATH=$PATH:$HOME/.roswell/bin
fi

# go設定
if [[ -s $HOME/dev/go ]]; then
    export GOPATH=$HOME/dev/go
    export PATH=$PATH:/usr/local/opt/go/libexec/bin:$HOME/dev/go/bin
fi

# docker設定
# export DOCKER_HOST=tcp://192.168.59.103:2376
# export DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
# export DOCKER_TLS_VERIFY=1

## screen セッション保存Dir
export SCREENDIR=$HOME/.screens

## screeninator
[[ -s "$HOME/.screeninator/scripts/screeninator" ]] && source "$HOME/.screeninator/scripts/screeninator"

## autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

## HOMEBREW CASKのインストール先
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

## エディタの指定
EDITOR=vim

## SVNのエディタ指定
SVN_EDITOR=vim

## PAGER設定
if [ -x /usr/bin/lv ]; then
  export PAGER='lv'
fi

## ロケール設定
LANG=ja_JP.UTF-8
export LC_ALL=$LANG

## 補完リストが多いときに尋ねる数
## -1 : 尋ねない
##  0 : ウィンドウから溢れるときは尋ねる
LISTMAX=0

export PATH EDITOR SVN_EDITOR LANG LC_ALL LISTMAX PAGER
