## 256カラー一覧を出力
function 256color-list() {
  for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo
}

## 文字列をコメント文字で囲んだりアスキーアートを作ったり
function art-boxes() {
  echo $1 | nkf -We | boxes -a c -s $2 -d $3 | nkf -Ew
}

## Qiitaへ投稿してるマークダウン取得
function qiita_md() {
  if [ $1 ]; then
    curl -s https://qiita.com/api/v1/items/$1 | php -R 'print_r(json_decode($argn)->raw_body);'
  else
    echo "QiitaHash of the argument does not exist"
  fi
}

## githubへアクセス
function gh() {
  if [ $1 ]; then
    hub browse -- commit/$1
  else
    hub browse
  fi
}
