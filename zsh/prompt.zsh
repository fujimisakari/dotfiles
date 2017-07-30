
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Prompt Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

autoload vcs_info
# gitのみ有効にする
zstyle ":vcs_info:*" enable git
# commitしていない変更をチェックする
#zstyle ":vcs_info:git:*" check-for-changes true
# gitリポジトリに対して、変更情報とリポジトリ情報を表示する
zstyle ":vcs_info:git:*" formats "⭠ %r ⮁ %b%u%c"
# gitリポジトリに対して、コンフリクトなどの情報を表示する
zstyle ":vcs_info:git:*" actionformats "⭠ %r ⮁ %b%u%c ⮁ %a"
# addしていない変更があることを示す文字列
zstyle ":vcs_info:git:*" unstagedstr " ⮁ Unstaged"
# commitしていないstageがあることを示す文字列
zstyle ":vcs_info:git:*" stagedstr " ⮁ Staged"

git_is_track_branch(){
    if [ "$(git remote 2>/dev/null)" != "" ]; then
        local target_tracking_branch="origin/$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        for tracking_branch in $(git branch -ar) ; do
            if [ "$target_tracking_branch" = "$tracking_branch" ]; then
                echo "true"
            fi
        done
    fi
}

git_info_pull(){
    if [ -n "$(git_is_track_branch)" ]; then
        local current_branch="$(git rev-parse --abbrev-ref HEAD)"
        local head_rev="$(git rev-parse HEAD)"
        local origin_rev="$(git rev-parse origin/$current_branch)"
        if [ "$head_rev" != "$origin_rev" ] && [ "$(git_info_push)" = "" ]; then
                echo " ⮁ Can Be Pulled"
        fi
    fi
}

git_info_push(){
    if [ -n "$(git_is_track_branch)" ]; then
        local current_branch="$(git rev-parse --abbrev-ref HEAD)"
        local push_count=$(git rev-list origin/"$current_branch".."$current_branch" 2>/dev/null | wc -l)
        if [ "$push_count" -gt 0 ]; then
            echo " ⮁ Can Be Pushed($push_count)"
        fi
    fi
}

case "${TERM}" in
    eterm-color*|kterm*|xterm*|screen*)

        function update_git_info() {
            LANG=en_US.UTF-8 vcs_info
            _vcs_info=$vcs_info_msg_0_
            _git_info_push=$(git_info_push)
            _git_info_pull=$(git_info_pull)
            if [ -n "$_vcs_info" ]; then
                local BG_COLOR=034
                local FG_COLOR=016

                if [ -n "$_git_info_push" ] || [ -n "$_git_info_pull" ]; then
                  BG_COLOR=184
                  FG_COLOR=016
                fi

                if [[ -n `echo $_vcs_info | grep -Ei "merge|unstaged|staged" 2> /dev/null` ]]; then
                    BG_COLOR=196
                    FG_COLOR=255
                fi
                # echo "%{%K{$BG_COLOR}%}⮀%{%F{$FG_COLOR}%} $_vcs_info$_git_info_push$_git_info_pull %{%F{$BG_COLOR}%K{magenta}%}⮀"
                echo "%{\e[48;5;${BG_COLOR}m%}%{\e[38;5;063m%}⮀%{\e[m%}%{\e[48;5;${BG_COLOR}m%} %{\e[38;5;${FG_COLOR}m%}$_vcs_info$_git_info_push$_git_info_pull %{\e[m%}%{\e[m%}%{\e[48;5;238m%}%{\e[38;5;${BG_COLOR}m%}⮀%{\e[m%}%{\e[m%}"
            else
               # echo "%{%K{magenta}%}⮀"
               echo -n "%{\e[48;5;238m%}%{\e[38;5;063m%}⮀%{\e[m%}%{\e[m%}"
            fi
        }

        function virtualenv_info {
            [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`')'
        }

        precmd() {
            if [[ -n `pwd | grep project 2> /dev/null` ]]; then
                zstyle ":vcs_info:git:*" check-for-changes false
            else
                # zstyle ":vcs_info:git:*" check-for-changes true
            fi
        }

        # プロンプト詳細
        #   %{%B%}...%{%b%}: 「...」を太字にする。
        #   %K{red}...%{%k%}: 「...」を赤の背景色にする。
        #   %{%F{cyan}%}...%{%f%}: 「...」をシアン色の文字にする。
        #   %n: ユーザ名
        #   %?: 最後に実行したコマンドの終了ステータス
        #   %(x.true-text.false-text): xが真のときはtrue-textになり
        #                              偽のときはfalse-textになる。
        #   %{%B%F{white}%(?.%K{green}.%K{red})%}%?%{%f%k%b%}:
        #                           最後に実行したコマンドが正常終了していれば
        #                           太字で白文字で緑背景にして異常終了していれば
        #                           太字で白文字で赤背景にする。
#         PROMPT_HOST='%{%b%F{gray}%K{blue}%} %(?.%{%F{green}%}✔.%{%F{red}%}✘)%{%F{black}%} %n %{%F{blue}%}'
#         PROMPT_DIR='%{%F{black}%} %~%  '
#         PROMPT_SU='%(!.%{%k%F{blue}%K{black}%}⮀%{%F{yellow}%} ⚡ %{%k%F{black}%}.%{%k%F{magenta}%})⮀%{%f%k%b%}'
#         PROMPT='
# %{%f%b%k%}$PROMPT_HOST$(update_git_info)$PROMPT_DIR$PROMPT_SU
# %{%f%b%K{blue}%} %{%F{black}%}$ %{%k%F{blue}⮀%{%f%k%b%} '
        PROMPT_HOST=$'%{\e[48;5;063m%} %(?.%{\e[38;5;077m%}✔.%{\e[38;5;196m%}✘) %{\e[38;5;016m%}%n %{\e[m%}%{\e[m%}'
        PROMPT_DIR=$'%{\e[48;5;238m%} %{\e[38;5;226m%}%~ %{\e[m%}% %{\e[m%}'
        PROMPT_SU=$'%(!.%{%k%F{blue}%K{black}%}⮀%{%F{yellow}%} ⚡ %{%k%F{black}%}.%{\e[38;5;238m%}⮀%{\e[m%})'
        PROMPT_SHELL=$'%{\e[48;5;247m%} %{\e[38;5;016m%}$ %{\e[m%}%{\e[m%}%{\e[38;5;247m%}⮀%{\e[m%}'
        # 128
        PROMPT=$'
$PROMPT_HOST$(update_git_info)$PROMPT_DIR$PROMPT_SU
$PROMPT_SHELL%{%f%k%b%} '
        SPROMPT='${WHITE}%r is correct? [n,y,a,e]: %{$reset_color%}'
    ;;
    # trampでの接続用
    dumb*)
        PROMPT="%m:%~> "
        unsetopt zle
    ;;
    *)
        PROMPT="${GREEN}%m${MAGENTA}%# %{$reset_color%}"
        PROMPT2="${WHITE}%_>%{$reset_color%}"
        SPROMPT="${WHITE}%r is correct? [n,y,a,e]: %{$reset_color%}"
    ;;
esac
