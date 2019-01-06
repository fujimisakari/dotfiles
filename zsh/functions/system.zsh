
## cd の後 ls も実行
case "${OSTYPE}" in
  linux*)
    function chpwd() {
      ls -F --color=auto
    }
  ;;
  darwin*)
    function chpwd() { ls -FG }
  ;;
esac

## 上の階層へ移動
function up-dir() {
  cd ../
  zle accept-line
}
zle -N up-dir

## 引数のファイルを utf8 や euc に変換
# -w utf8  -e euc -Lu 改行コードをLFにする
function nkf_utf() {
  for i in ${@}; do;
    nkf -w -Lu --overwrite ${i}
  done;
}
function nkf_euc() {
  for i in ${@}; do;
    nkf -e -Lu --overwrite ${i}
  done;
}

## 画像サイズを出力する
function imgsize() {
  for i in ${@}; do;
    identify ${i} | awk '{print $1, $3}'
  done;
}

## カレント画像サイズを出力する
function imgsize_all() {
  for i in $(ls); do
    identify ${i} | awk '{print $1, $3}'
  done
}
