
##------------------------------------------------------------------##
#                         各種設定の読み込み                         #
##------------------------------------------------------------------##

## colors
if [ -f $ZSHUSERDIR/colors ]; then
    source $ZSHUSERDIR/colors
fi

## aliases
if [ -f $ZSHUSERDIR/aliases ]; then
    source $ZSHUSERDIR/aliases
fi

## functions
if [ -f $ZSHUSERDIR/functions ]; then
    source $ZSHUSERDIR/functions
fi

## autojump.zsh
fpath=($fpath $ZSHUSERDIR/lib(N))
if [ -f $ZSHUSERDIR/autojump.zsh ]; then
    source $ZSHUSERDIR/autojump.zsh
fi

## emacs
#if [ $HOST = "gajumaru" ]; then
#    source $ZSHUSERDIR/emacs
#fi


##------------------------------------------------------------------##
#                          プロンプト関係                            #
##------------------------------------------------------------------##

autoload -U colors
colors

local GRAY=$'%{\e[1;30m%}'
local RED=$'%{\e[1;31m%}'
local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[0;34m%}'
local MAGENTA=$'%{\e[1;35m%}'
local CYAN=$'%{\e[1;36m%}'
local LIGHT_GRAY=$'%{\e[1;37m%}'
local WHITE=$'%{\e[1;37m%}'

case "${TERM}" in
    eterm-color*|kterm*|xterm*|screen*)
        # プロンプト表示前に実行
        precmd() {
            echo ""
            # ターミナルのタイトル
            case "${TERM}" in
                kterm*|xterm*)
                    echo -n "\e]2;${HOST} : ${PWD}\a"
                ;;
                screen*)
                    echo -ne "\ek\e\\"; print -Pn "\e]0; %~\a"
            esac
        }
        PROMPT=$'$BLUE<$RED%h$BLUE>[$YELLOW%D{%m}$BLUE/$YELLOW%D{%d}$BLUE-$YELLOW%D{%H}$BLUE:$YELLOW%D{%M}$BLUE:$YELLOW%D{%S}$BLUE]($GREEN%/$BLUE)\n$GREEN%m$MAGENTA%# %{$reset_color%}'
        PROMPT2="$WHITE%_>%{$reset_color%}"
        SPROMPT="$WHITE%r is correct? [n,y,a,e]: %{$reset_color%}"

        ## コマンド実行直後に実行
        preexec() {
            local HOUR="`date +%k`"
            local MINUTE="`date +%M`"
            local SECOND="`date +%S`"
            echo -e "\e[34m[\e[m\e[1;33m$HOUR\e[m\e[34m:\e[m\e[1;33m$MINUTE\e[m\e[34m:\e[m\e[1;33m$SECOND\e[m\e[34m]\e[m\n"
        }
    ;;
    # trampでの接続用
    dumb*)
        PROMPT="%m:%~> "
        unsetopt zle
    ;;
    *)
        PROMPT="$GREEN%m$MAGENTA%# %{$reset_color%}"
        PROMPT2="$WHITE%_>%{$reset_color%}"
        SPROMPT="$WHITE%r is correct? [n,y,a,e]: %{$reset_color%}"
    ;;
esac

# 端末元が ratpoison or emacs だった場合は screen で立ち上げる
if [ $TERM = "eterm-color" -o $ALLOW_HOST = "true" ]; then
    if [ $TERM != "screen-bce" ]; then
        scrin
    fi
fi


##------------------------------------------------------------------##
#                             履歴関係                               #
##------------------------------------------------------------------##

HISTFILE=~/.zsh_history      # ヒストリファイルを指定
HISTSIZE=100000              # ヒストリに保存するコマンド数
SAVEHIST=100000              # ヒストリファイルに保存するコマンド数
setopt hist_ignore_all_dups  # 重複するコマンド行は古い方を削除
setopt hist_ignore_dups      # 直前と同じコマンドラインはヒストリに追加しない
setopt share_history         # コマンド履歴ファイルを共有する
setopt append_history        # 履歴を追加 (毎回 .zsh_history を作るのではなく)
setopt inc_append_history    # 履歴をインクリメンタルに追加
setopt hist_no_store         # historyコマンドは履歴に登録しない
setopt hist_reduce_blanks    # 余分な空白は詰めて記録
setopt hist_ignore_space     # 先頭がスペースの場合、ヒストリに追加しない
setopt pushd_ignore_dups     # ディレクトリスタックに重複する物は古い方を削除
setopt extended_history      # ディレクトリスタックに重複する物は古い方を削除


##------------------------------------------------------------------##
#                             補完関係                               #
##------------------------------------------------------------------##

autoload -U compinit     # 標準の補完設定
compinit
#setopt auto_cd           # ディレクトリ名を入力するだけでカレントディレクトリを変更
setopt auto_menu         # タブキー連打で補完候補を順に表示
setopt correct           # 自動修正機能(候補を表示)
setopt list_packed       # 補完候補を詰めて表示
setopt list_types        # 補完候補一覧でファイルの種別を識別マーク表示(ls -F の記号)
setopt noautoremoveslash # パスの最後に付くスラッシュを自動的に削除しない
setopt magic_equal_subst # = 以降でも補完できるようにする( --prefix=/usr 等の場合)
setopt print_eight_bit   # 補完候補リストの日本語を正しく表示
setopt auto_param_keys   # カッコ対応などを自動補完
setopt completeinword    # 単語の途中にカーソルをおいて補完する
setopt GLOB_DOTS         # `.' で開始するファイル名にマッチさせるとき、先頭に明示的に `.' を指定する必要がなくなる
setopt auto_pushd        # cd - と入力してTabキーで今までに移動したディレクトリを一覧表示
setopt complete_aliases  # 補完される前にエリアスコマンドのオリジナルまで展開してチェックする

## 補完候補の矢印キーで移動有効
zstyle ':completion:*:default' menu select=1

## 補完の時に大文字小文字を区別しない(但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## sudoでも補完ができるようにする
zstyle ':completion:*:sudo:*'\
command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin 

## kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

## .ssh/configに指定したホストをsshなどの補完候補に
hosts=( ${(@)${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && <~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*} )
zstyle ':completion:*:hosts' hosts $hosts

## 補完候補に色をつける
case "${OSTYPE}" in
    linux*)
        zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
    ;;
    darwin*)
        zstyle ':completion:*' list-colors \
        'di=34' 'ln=01;36' 'so=32' 'ex=32' 'bd=46;34' 'cd=43;34'
    ;;
esac


##------------------------------------------------------------------##
#                         キーチェイン設定                           #
##------------------------------------------------------------------##

if [ $ALLOW_HOST = "true" ]; then
    if ssh-add -l > /dev/null 2>&1; [ $? -eq 0  ]; then
        keychain
        . ~/.keychain/$HOST-sh
    elif ssh-add -l > /dev/null 2>&1; [ $? -eq 1  ]; then
        echo "Please input the passphrase to ssh-agent"
        ssh-add ~/.ssh/id_rsa
        keychain
    elif psg ssh-agent > /dev/null 2>&1; [ $? -eq 0  ]; then
        . ~/.keychain/$HOST-sh
    else
        echo "Please input the passphrase to ssh-agent"
        keychain ~/.ssh/id_rsa
        . ~/.keychain/$HOST-sh
    fi
fi


##------------------------------------------------------------------##
#                              その他                                #
##------------------------------------------------------------------##

setopt prompt_subst          # プロンプトに環境変数を通す
setopt no_beep               # ビープ音を消す
#setopt nolistbeep           # 補完候補表示時などにビープ音を鳴らさない
#setopt interactive_comments # コマンドラインで # 以降をコメントとする
setopt numeric_glob_sort     # 辞書順ではなく数値順でソート
setopt no_multios            # zshのリダイレクト機能を制限する
unsetopt promptcr            # 改行コードで終らない出力もちゃんと出力する
setopt ignore_eof            # Ctrl-dでログアウトしない
setopt no_hup                # ログアウト時にバックグラウンドジョブをkillしない
setopt no_checkjobs          # ログアウト時にバックグラウンドジョブを確認しない
setopt notify                # バックグラウンドジョブが終了したら(プロンプトの表示を待たずに)すぐに知らせる
#setopt rm_star_wait         # rm * を実行する前に確認
setopt rm_star_silent        # rm * を実行する前に確認しない
#setopt no_clobber           # リダイレクトで上書きを禁止
unsetopt no_clobber          # リダイレクトで上書きを許可
#setopt chase_links          # シンボリックリンクはリンク先のパスに変換してから実行
#setopt print_exit_value     # 戻り値が 0 以外の場合終了コードを表示
#setopt single_line_zle      # デフォルトの複数行コマンドライン編集ではなく、１行編集モードになる

umask 022                             # ファイル作成時のパーミッション
bindkey -e                            # bindkeyはemacs
bindkey -r "^J"                       # "^J"のキーバインドを削除
#bindkey "^h" backward-kill-word      # Ctrl-h で単語ごとに削除
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'    # / を単語の一部とみなさない記号の環境変数から削除
typeset -U path cdpath fpath manpath  # 重複する要素を自動的に削除

# macのターミナルは、uim-skkを利用する
if [ `uname` = "Darwin" ]; then
    case "${TERM}" in 
        screen*)
            uim-fep
        ;;
    esac
fi

