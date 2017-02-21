
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Enviroment Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

case "${OSTYPE}" in
  linux*)
    PATH=$HOME/misc/bin:$HOME/.pyenv/bin:$PATH:/sbin:/usr/sbin
  ;;
  darwin*)
    PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$HOME/.pyenv/bin:/sbin:/usr/sbin:$HOME/misc/bin:$PATH
    export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
  ;;
esac

## Python
export PYTHONDONTWRITEBYTECODE=1  # pycは作らない
export WERKZEUG_DEBUG_PIN='off'   # for Django-extentions
PYTHONPATH=$HOME/misc/lib:$PYTHONPATH
export PYTHONPATH

if [ -e "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

## PHP
if [ -e "$HOME/.phpenv" ]; then
    PATH="$HOME/.phpenv/bin:$PATH"
    eval "$(phpenv init -)"
fi

if [ -e "$HOME/dev/php/bin" ]; then
    PATH="$HOME/dev/php/bin:$PATH"
fi

## anyenv
if [ -e "$HOME/.anyenv" ]; then
    PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
fi

## Google App Engin
if [ -e "$HOME/dev/google-cloud-platform" ]; then
    export CLOUDSDK_PYTHON=/usr/bin/python
    # The next line updates PATH for the Google Cloud SDK.
    source "$HOME/dev/google-cloud-platform/google-cloud-sdk/path.zsh.inc"
    # The next line enables shell command completion for gcloud.
    source "$HOME/dev/google-cloud-platform/google-cloud-sdk/completion.zsh.inc"
fi

## Ruby
if [[ -s $HOME/.rvm/scripts/rvm ]]; then
    source $HOME/.rvm/scripts/rvm  # Load RVM function
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
    # デフォルトのrubyバージョン、gemライブラリ場所を指定
    # rvm use 1.8.7
    rvm gemset use default_env > /dev/null 2>&1
fi

## Node.js(nodebrew)
export PATH=$HOME/.nodebrew/current/bin:$PATH
# if [[ -s ~/.nvm/nvm.sh ]];
#     then source ~/.nvm/nvm.sh
# fi

## Common Lisp
if [[ -s $HOME/.roswell ]]; then
    PATH=$PATH:$HOME/.roswell/bin
fi

## Go
if [[ -s $HOME/dev/go ]]; then
    export GOPATH=$HOME/dev/go
    export PATH=$PATH:/usr/local/opt/go/libexec/bin:$HOME/dev/go/bin
fi

## Docker
if [[ -s $HOME/.docker ]]; then
    export DOCKER_HOST="tcp://192.168.99.100:2376"
    export DOCKER_MACHINE_NAME="default"
    export DOCKER_TLS_VERIFY="1"
    export DOCKER_CERT_PATH="$HOME/.docker/machine/machines/default"
fi

## screen セッション保存Dir
export SCREENDIR=$HOME/.screens

## screeninator
[[ -s "$HOME/.screeninator/scripts/screeninator" ]] && source "$HOME/.screeninator/scripts/screeninator"

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