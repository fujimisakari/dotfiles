
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Color Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

# directory
LS_COLORS="$LS_COLORS:di=00;34"

# archive
LS_COLORS="$LS_COLORS:*.rpm=01;31"
LS_COLORS="$LS_COLORS:*.tar=01;31:*.gz=01;31:*.tgz=01;31:*.z=01;31:*.bz2=01;31"
LS_COLORS="$LS_COLORS:*.lzh=01;31:*.zip=01;31"
LS_COLORS="$LS_COLORS:*.RPM=01;01;31"
LS_COLORS="$LS_COLORS:*.TAR=01;31:*.GZ=01;31:*.TGZ=01;31:*.Z=01;31:*.BZ2=01;31"
LS_COLORS="$LS_COLORS:*.LZH=01;31:*.ZIP=01;31"

# text
#LS_COLORS="$LS_COLORS:*.txt=36"
#LS_COLORS="$LS_COLORS:*.TXT=36"

# program text
#LS_COLORS="$LS_COLORS:*.txc=01;32:*.c=01;32:*.h=01;32"
#LS_COLORS="$LS_COLORS:*.TXC=01;32:*.C=01;32:*.H=01;32"

# extra text
#LS_COLORS="$LS_COLORS:*.nov=01;32"
#LS_COLORS="$LS_COLORS:*.htm=01;34:*.html=01;34"
#LS_COLORS="$LS_COLORS:*.NOV=01;32"
#LS_COLORS="$LS_COLORS:*.HTM=01;34:*.HTML=01;34"

# multi media
LS_COLORS="$LS_COLORS:*.mp3=01;35:*.mid=01;35:*.wav=01;35:*.mod=01;35"
LS_COLORS="$LS_COLORS:*.avi=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35"
LS_COLORS="$LS_COLORS:*.MP3=01;35:*.MID=01;35:*.WAV=01;35:*.MOD=01;35"
LS_COLORS="$LS_COLORS:*.AVI=01;35:*.MOV=01;35:*.MPG=01;35:*.MPEG=01;35"

# graphics
LS_COLORS="$LS_COLORS:*.jpg=01;35:*.jpeg=01;35:*.bmp=01;35:*.gif=01;35:*.png=01;35"
LS_COLORS="$LS_COLORS:*.xpm=01;35:*.xbm=01;35:*.xwd=01;35:*.xcf=01;35"
LS_COLORS="$LS_COLORS:*.JPG=01;35:*.JPEG=01;35:*.BMP=01;35:*.GIF=01;35:*.PNG=01;35"
LS_COLORS="$LS_COLORS:*.XPM=01;35:*.XBM=01;35:*.XWD=01;35:*.XCF=01;35"

# grep
GREP_COLOR="01;37;41"
GREP_OPTIONS=--color=auto

# export
export LS_COLORS GREP_COLOR GREP_OPTIONS

if [ `uname` = "Darwin" ]; then
    # ls設定(Default)exfxcxdxbxegedabagacad
    export LSCOLORS='exGxcxdxCxegedabagacad'
fi

## Mac ##
# 1.   directory
# 2.   symbolic link
# 3.   socket
# 4.   pipe
# 5.   executable
# 6.   block special
# 7.   character special
# 8.   executable with setuid bit set
# 9.   executable with setgid bit set
# 10.  directory writable to others, with sticky bit
# 11.  directory writable to others, without sticky bit

# a     black
# b     red
# c     green
# d     brown
# e     blue
# f     magenta
# g     cyan
# h     light grey
# A     bold black, usually shows up as dark grey
# B     bold red
# C     bold green
# D     bold brown, usually shows up as yellow
# E     bold blue
# F     bold magenta
# G     bold cyan
# H     bold light grey; looks like bright white
# x     default foreground or background

## Linux ##
# 00: なにもしない
# 01: 太字化
# 04: 下線
# 05: 点滅
# 07: 前背色反転
# 08: 表示しない
# 22: ノーマル化
# 24: 下線なし
# 25: 点滅なし
# 27: 前背色反転なし
# 30: 黒(前景色)
# 31: 赤(前景色)
# 32: 緑(前景色)
# 33: 黄(前景色)
# 34: 青(前景色)
# 35: マゼンタ(前景色)
# 36: シアン(前景色)
# 37: 白(前景色)
# 39: デフォルト(前景色)
# 40: 黒(背景色)
# 41: 赤(背景色)
# 42: 緑(背景色)
# 43: 黄(背景色)
# 44: 青(背景色)
# 45: マゼンタ(背景色)
# 46: シアン(背景色)
# 47: 白(背景色)
# 49: デフォルト(背景色)

# a: 黒
# b: 赤
# c: 緑
# d: 茶
# e: 青
# f: マゼンタ
# g: シアン
# h: 白
# A: 黒(太字)
# B: 赤(太字)
# C: 緑(太字)
# D: 茶(太字)
# E: 青(太字)
# F: マゼンタ(太字)
# G: シアン(太字)
# H: 白(太字)
# x: デフォルト色

# di: ディレクトリ
# ln: シンボリックリンク
# so: ソケットファイル
# pi: FIFOファイル
# ex: 実行ファイル
# bd: ブロックスペシャルファイル
# cd: キャラクタスペシャルファイル
# su: setuidつき実行ファイル
# sg: setgidつき実行ファイル
# tw: スティッキビットありother書き込み権限つきディレクトリ
# ow: スティッキビットなしother書き込み権限つきディレクトリ

# 01: ディレクトリ前景色
# 02: ディレクトリ背景色
# 03: シンボリックリンク前景色
# 04: シンボリックリンク背景色
# 05: ソケットファイル前景色
# 06: ソケットファイル背景色
# 07: FIFOファイル前景色
# 08: FIFOファイル背景色
# 09: 実行ファイル前景色
# 10: 実行ファイル背景色
# 11: ブロックスペシャルファイル前景色
# 12: ブロックスペシャルファイル背景色
# 13: キャラクタスペシャルファイル前景色
# 14: キャラクタスペシャルファイル背景色
# 15: setuidつき実行ファイル前景色
# 16: setuidつき実行ファイル背景色
# 17: setgidつき実行ファイル前景色
# 18: setgidつき実行ファイル背景色
# 19: スティッキビットありother書き込み権限つきディレクトリ前景色
# 20: スティッキビットありother書き込み権限つきディレクトリ背景色
# 21: スティッキビットなしother書き込み権限つきディレクトリ前景色
# 22: スティッキビットなしother書き込み権限つきディレクトリ背景色
