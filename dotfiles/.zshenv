
##------------------------------------------------------------------##
#                            環境変数設定                            #
##------------------------------------------------------------------##

## 開発環境PCか判定
for host_name in "gajumaru" "jupiter" "universe"
do
    if [ $HOST = $host_name ]; then
        ALLOW_HOST="true"
        break
    fi
    ALLOW_HOST="false"
done

## パスの追加
case "${OSTYPE}" in
  linux*)
    PATH=$PATH:/sbin:/usr/sbin:$HOME/misc/bin
  ;;
  darwin*)
    PATH=/usr/local/bin:$PATH:/sbin:$HOME/misc/bin
  ;;
esac

if [ $ALLOW_HOST = "true" ]; then
  PATH=$PATH:$HOME/.emacs.d/bin
fi

## 個人設定ファイルパス
ZSHUSERDIR=$HOME/misc

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
