
##------------------------------------------------------------------##
#                           開発環境PC判定                           #
##------------------------------------------------------------------##

for host_name in "gajumaru" "jupiter.local" "universe"
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
ZSHUSERDIR=$HOME/misc

## zsh補完アーカイブパス
COMPLETIONDIR=$HOME/misc/completion
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

## autojump
if [ -f $ZSHUSERDIR/lib/autojump.zsh ]; then
    source $ZSHUSERDIR/lib/autojump.zsh
fi

## emacs
#if [ $HOST = "gajumaru" ]; then
#    source $ZSHUSERDIR/lib/emacs
#fi


##------------------------------------------------------------------##
#                            環境変数設定                            #
##------------------------------------------------------------------##

# 端末元が 開発PC or emacs だった場合は screen で立ち上げる
if [ $TERM = "eterm-color" -o $ALLOW_HOST = "true" ] && [ $TERM_PROGRAM != "Apple_Terminal" ]; then
    if [ $TERM != "screen-bce" ]; then
        scrin
    fi
fi

## パスの追加
case "${OSTYPE}" in
  linux*)
    PATH=$PATH:/sbin:/usr/sbin:$HOME/misc/bin
  ;;
  darwin*)
    PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH:/sbin:$HOME/misc/bin
    export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
  ;;
esac

## 開発環境設定
if [ $HOST = "jupiter.local" ]; then
    # gccを指定
    export CC=/usr/bin/gcc-4.2

    # python設定
    export PYTHONDONTWRITEBYTECODE=1  # pycは作らない

    [[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc
    VIRTUALENVWRAPPER_PYTHON_BIN=${HOME}/.pythonbrew/pythons/Python-2.7.2/bin
    export VIRTUALENVWRAPPER_PYTHON=${VIRTUALENVWRAPPER_PYTHON_BIN}/python
    [[ -d ${VIRTUALENVWRAPPER_PYTHON_BIN} ]] && source ${VIRTUALENVWRAPPER_PYTHON_BIN}/virtualenvwrapper.sh

    PYTHONPATH=$HOME/misc/lib:$PYTHONPATH
    export PYTHONPATH

    # ruby設定
    [[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm  # Load RVM function
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
    # デフォルトのrubyバージョン、gemライブラリ場所を指定
    # rvm use 1.8.7
    rvm gemset use default_env
fi

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

## 補完リストが多いときに尋ねる数
## -1 : 尋ねない
##  0 : ウィンドウから溢れるときは尋ねる
LISTMAX=0

export PATH EDITOR SVN_EDITOR LANG LC_ALL LISTMAX PAGER
