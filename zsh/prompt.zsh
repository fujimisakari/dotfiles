
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Prompt Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

autoload vcs_info
# gitのみ有効にする
zstyle ":vcs_info:*" enable git
# commitしていない変更をチェックする
#zstyle ":vcs_info:git:*" check-for-changes true
# gitリポジトリに対して、変更情報とリポジトリ情報を表示する
zstyle ":vcs_info:git:*" formats " \uE709 %r \uE0BF  \uE0A0 %b%u%c"
# gitリポジトリに対して、コンフリクトなどの情報を表示する
zstyle ":vcs_info:git:*" actionformats " \uE709 %r \uE0BF  \uE0A0 %b%u%c \uE0BF  %a"
# addしていない変更があることを示す文字列
zstyle ":vcs_info:git:*" unstagedstr "\uE0BF  Unstaged"
# commitしていないstageがあることを示す文字列
zstyle ":vcs_info:git:*" stagedstr "\uE0BF  Staged"

function git_is_track_branch() {
  if [ "$(git remote 2>/dev/null)" != "" ]; then
    local target_tracking_branch="origin/$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    for tracking_branch in $(git branch -ar) ; do
      if [ "${target_tracking_branch}" = "${tracking_branch}" ]; then
        echo "true"
      fi
    done
  fi
}

function git_info_pull() {
  if [ -n "$(git_is_track_branch)" ]; then
    local current_branch="$(git rev-parse --abbrev-ref HEAD)"
    local head_rev="$(git rev-parse HEAD)"
    local origin_rev="$(git rev-parse origin/$current_branch)"
    if [ "${head_rev}" != "${origin_rev}" ] && [ "$(git_info_push)" = "" ]; then
      echo " \uE0BF  Can Be Pulled"
    fi
  fi
}

function git_info_push() {
  if [ -n "$(git_is_track_branch)" ]; then
    local current_branch="$(git rev-parse --abbrev-ref HEAD)"
    local push_count=$(git rev-list origin/"${current_branch}".."${current_branch}" 2>/dev/null | wc -l | tr -d ' ')
    if [ "${push_count}" -gt 0 ]; then
      echo " \uE0BF  Can Be Pushed(${push_count})"
    fi
  fi
}

function update_git_info() {
  LANG=en_US.UTF-8 vcs_info
  local vcs_info=${vcs_info_msg_0_}
  local git_info_push=$(git_info_push)
  local git_info_pull=$(git_info_pull)
  if [ -n "${vcs_info}" ]; then
    local bg_color=034
    local fg_color=016

    if [ -n "${git_info_push}" ] || [ -n "${git_info_pull}" ]; then
      bg_color=184
      fg_color=016
    fi

    if [[ -n $(echo ${vcs_info} | grep -Ei "merge|unstaged|staged" 2> /dev/null) ]]; then
        bg_color=196
        fg_color=255
    fi
    echo "%{\e[48;5;${bg_color}m%}%{\e[38;5;063m%}\uE0B8%{\e[m%}%{\e[48;5;${bg_color}m%} %{\e[38;5;${fg_color}m%}${vcs_info}${git_info_push}${git_info_pull} %{\e[m%}%{\e[m%}%{\e[48;5;238m%}%{\e[38;5;${bg_color}m%}\uE0B8%{\e[m%}%{\e[m%}"
  else
    echo -n "%{\e[48;5;238m%}%{\e[38;5;063m%}\uE0B8%{\e[m%}%{\e[m%}"
  fi
}

case "${TERM}" in
  eterm-color*|kterm*|xterm*|screen*)
    precmd() {
      if [[ -n $(pwd | grep project 2> /dev/null) ]]; then
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
    #   iconチートシート: https://www.nerdfonts.com/cheat-sheet
    prompt_host=$'%{\e[48;5;063m%} %(?.%{\e[38;5;077m%}✔.%{\e[38;5;196m%}✘) %{\e[38;5;016m%}%n %{\e[m%}%{\e[m%}'
    prompt_dir=$'%{\e[48;5;238m%} %{\e[38;5;226m%} \uE5FE  %~ %{\e[m%}% %{\e[m%}'
    prompt_su=$'%(!.%{%k%F{blue}%K{black}%}\uE0B8%{%F{yellow}%} ⚡ %{%k%F{black}%}.%{\e[38;5;238m%}\uE0B8%{\e[m%})'
    prompt_shell=$'%{\e[48;5;247m%} %{\e[38;5;016m%}$ %{\e[m%}%{\e[m%}%{\e[38;5;247m%}\uE0B8%{\e[m%}'
    if [ `uname` = "Darwin" ]; then
      prompt_shell=$'%{\e[48;5;247m%} %{\e[38;5;016m%}\uE711  %{\e[m%}%{\e[m%}%{\e[38;5;247m%}\uE0B8%{\e[m%}'
    elif [ `uname` = "Linux" ]; then
      prompt_shell=$'%{\e[48;5;247m%} %{\e[38;5;016m%}\uF31B  %{\e[m%}%{\e[m%}%{\e[38;5;247m%}\uE0B8%{\e[m%}'
    fi
    PROMPT=$'
${prompt_host}$(update_git_info)${prompt_dir}${prompt_su}%{${reset_color}%}
${prompt_shell}  %{%f%k%b%}'
    SPROMPT='${white}%r is correct? [n,y,a,e]: %{${reset_color}%}'
  ;;
  # trampでの接続用
  dumb*)
    PROMPT="%m:%~> "
    unsetopt zle
  ;;
  *)
    PROMPT="${green}%m${magenta}%# %{${reset_color}%}"
    PROMPT2="${white}%_>%{${reset_color}%}"
    SPROMPT="${white}%r is correct? [n,y,a,e]: %{${reset_color}%}"
  ;;
esac
