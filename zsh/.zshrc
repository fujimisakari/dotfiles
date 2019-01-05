
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Load Each Setting File
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function loadlib() {
    lib=${1:?"You have to specify a library file"}
    if [ -f "$lib" ];then
        source "$lib"
    fi
}

ZSHUSERDIR=$HOME/dotfiles/zsh
loadlib $ZSHUSERDIR/aliases.zsh
loadlib $ZSHUSERDIR/functions/system.zsh
loadlib $ZSHUSERDIR/functions/docker.zsh
loadlib $ZSHUSERDIR/functions/emacs.zsh
loadlib $ZSHUSERDIR/functions/peco.zsh
loadlib $ZSHUSERDIR/functions/misc.zsh
loadlib $ZSHUSERDIR/prompt.zsh

case "${OSTYPE}" in
  linux*)
    loadlib $ZSHUSERDIR/functions/wifi.zsh
  ;;
esac


###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Key Chain Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

for host_name in "thinkpad" "fujimotoryou-no-MacBook-Pro.local"
do
    if [ $HOST = $host_name ]; then
        if ssh-add -l > /dev/null 2>&1; [ $? -eq 0 ]; then
            keychain
            . ~/.keychain/$HOST-sh
        elif ssh-add -l > /dev/null 2>&1; [ $? -eq 1 ]; then
            echo "Please input the passphrase to ssh-agent"
            ssh-add ~/.ssh/id_rsa
            keychain
        elif psg ssh-agent > /dev/null 2>&1; [ $? -eq 0 ]; then
            . ~/.keychain/$HOST-sh
        else
            echo "Please input the passphrase to ssh-agent"
            keychain ~/.ssh/id_rsa
            . ~/.keychain/$HOST-sh
        fi
    fi
done


###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  History Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HISTFILE=~/.zsh_history
HISTSIZE=250000              # ヒストリに保存するコマンド数
SAVEHIST=250000              # ヒストリファイルに保存するコマンド数
setopt hist_ignore_all_dups  # 重複するコマンド行は古い方を削除
setopt hist_ignore_dups      # 直前と同じコマンドラインはヒストリに追加しない
setopt share_history         # コマンド履歴ファイルを共有する
setopt append_history        # 履歴を追加 (毎回 .zsh_history を作るのではなく)
setopt inc_append_history    # 履歴をインクリメンタルに追加
setopt hist_no_store         # historyコマンドは履歴に登録しない
setopt hist_reduce_blanks    # 余分な空白は詰めて記録
setopt hist_ignore_space     # 先頭がスペースの場合、ヒストリに追加しない
setopt pushd_ignore_dups     # ディレクトリスタックに重複する物は古い方を削除
setopt extended_history      # ヒストリファイルに時刻を記録


###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Completion Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

COMPLETIONDIR=$HOME/dotfiles/zsh/completions
fpath=($fpath $COMPLETIONDIR)

# 標準の補完設定
autoload -U compinit
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
zstyle ':completion:*' list-colors "${LS_COLORS}"


###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Other Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
bindkey -r "^G"                       # "^J"のキーバインドを削除
bindkey "^[h" backward-kill-word      # M-h で単語ごとに削除
#bindkey "^h" backward-kill-word      # Ctrl-h で単語ごとに削除
bindkey "^R" peco-select-history      # コマンド履歴
bindkey "^Xs" peco-ssh                # ssh対象参照
bindkey '^Xb' peco-branch             # gitブランチ選択
bindkey '^Xc' peco-docker-containers  # dockerのコンテナIDを選択
bindkey '^Xi' peco-docker-images      # dockerのイメージIDを選択
bindkey '^Xr' peco-docker-run         # dockerコンテナのRun先を選択
bindkey '^Xe' peco-docker-exec        # dockerコンテナのexec先を選択
bindkey '^Xn' peco-kubectl-with-ns    # kubectlのnamespaceを選択
bindkey '^Xp' peco-kubectl-with-pod   # kubectlのpodを選択
bindkey "^L" peco-cdr                 # 最近行ったディレクトへcd
bindkey "^X'" peco-go-src             # go関連のリポジトリを参照
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'    # / を単語の一部とみなさない記号の環境変数から削除
typeset -U path cdpath fpath manpath  # 重複する要素を自動的に削除

# 最近行ったディレクトリに移動することができるようにするcdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

## create emacs env file
if [[ -s $HOME/.emacs.d ]]; then
    ~/.emacs.d/bin/env_genarator.py emacs > ~/.emacs.d/share/shellenv/`echo $USER`_shellenv.el
fi
