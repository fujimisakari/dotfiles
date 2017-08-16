
case "${OSTYPE}" in
  linux*)
    ## CPU 使用率の高い方から15つ
    function psc() {
      psa | head -n 1
      psa | sort -r -n -k 3 | grep -v "ps auxww" | grep -v grep | head -n 15
    }

    ## メモリ占有率の高い方から15つ
    function psm() {
      psa | head -n 1
      psa | sort -r -n -k 4 | grep -v "ps auxww" | grep -v grep | head -n 15
    }

    ## 全プロセスから引数の文字列を含むものを grep
    function psg() {
      psa | head -n 1                                    # ラベルを表示
      psa | grep $* | grep -v "ps auxww" | grep -v grep  # grep プロセスを除外
    }

    ## cd の後 ls も実行
    function chpwd() {
      ls -F --color=auto
    }
  ;;
  darwin*)
    ## cd の後 ls も実行
    function chpwd() { ls -FG }
  ;;
esac

## 上の階層へ移動
function up-dir() {
    cd ../
    zle accept-line
}
zle -N up-dir

## 全履歴一覧を出力する
function histall { history -i -D -E 1 }

## 引数のファイルを utf8 や euc に変換
# -w utf8  -e euc -Lu 改行コードをLFにする
function nkf_utf() {
  for i in $@; do;
    nkf -w -Lu --overwrite $i
  done;
}
function nkf_euc() {
  for i in $@; do;
      nkf -e -Lu --overwrite $i
  done;
}

## SSHコマンドはscreenの新しい窓で
if [ x$TERM = xscreen-bce ]; then
  function ssh_screen(){
    eval server=\${$#}
    name="$(echo $server | cut -d '@' -f 2)"
    screen -t $name ssh -l $USER "$@"
  }
  alias ssh=ssh_screen
fi

## screenのショートカットコマンド
function sl { screen -ls }
function sr { screen -r $1 }

## 画像サイズを出力する
function imgsize() {
  for i in $@; do;
    identify $i | awk '{print $1, $3}'
  done;
}

## カレント画像サイズを出力する
function imgsize_all() {
  for i in `ls`; do
    identify $i | awk '{print $1, $3}'
  done
}
