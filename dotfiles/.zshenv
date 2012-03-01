
##------------------------------------------------------------------##
#                            環境変数設定                            #
##------------------------------------------------------------------##

## パスの追加
case "${OSTYPE}" in
  linux*)
    PATH=$PATH:/sbin:/usr/sbin:$HOME/misc/bin
  ;;  
  darwin*)
    PATH=/usr/local/bin:$PATH:/sbin:$HOME/misc/bin
  ;;  
esac

## 個人設定ファイルパス
ZSHUSERDIR=$HOME/misc

## エディタの指定
if [ $HOST = "gajumaru" ]; then
  PATH=$PATH:$HOME/.emacs.d/bin
  EDITOR=emacsclient
  export VISUAL=emacsclient
else
  export GDMSESSION="dummy"
  EDITOR=vim
fi

## PAGER設定
if [ -x /usr/bin/lv ]; then
  export PAGER='lv'
fi

## SVNのエディタ指定
SVN_EDITOR=vim

## ロケール設定
LANG=ja_JP.UTF-8

## 補完リストが多いときに尋ねる数
## -1 : 尋ねない
##  0 : ウィンドウから溢れるときは尋ねる
LISTMAX=0

export PATH ZSHUSERDIR EDITOR SVN_EDITOR LANG LC_ALL LISTMAX PAGER
