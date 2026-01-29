
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Prompt Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

autoload vcs_info
# gitのみ有効にする
zstyle ":vcs_info:*" enable git
# commitしていない変更をチェックする
#zstyle ":vcs_info:git:*" check-for-changes true

# OS別セパレータ・アイコン設定
case `uname` in
  Darwin)
    _git_sep="\uE0BF"
    _git_corner="\uE0B8"
    zstyle ":vcs_info:git:*" formats " \uE709  %r ${_git_sep}  \uE0A0 %b%u%c"
    zstyle ":vcs_info:git:*" actionformats " \uE709  %r ${_git_sep}  \uE0A0 %b%u%c ${_git_sep}  %a"
    zstyle ":vcs_info:git:*" unstagedstr "${_git_sep}  Unstaged"
    zstyle ":vcs_info:git:*" stagedstr "${_git_sep}  Staged"
  ;;
  Linux)
    _git_sep="╲"
    _git_corner="◣"
    zstyle ":vcs_info:git:*" formats "\uE709 %r ${_git_sep} \uE0A0 %b%u%c"
    zstyle ":vcs_info:git:*" actionformats " \uE709  %r ${_git_sep} \uE0A0 %b%u%c ${_git_sep} %a"
    zstyle ":vcs_info:git:*" unstagedstr "${_git_sep} Unstaged"
    zstyle ":vcs_info:git:*" stagedstr "${_git_sep} Staged"
  ;;
esac

# push/pull情報を効率的に取得
function _git_status_info() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
  local remote_branch="origin/${current_branch}"

  # リモートブランチが存在するか確認
  if git rev-parse --verify "${remote_branch}" &>/dev/null; then
    local ahead behind
    ahead=$(git rev-list "${remote_branch}..HEAD" 2>/dev/null | wc -l | tr -d ' ')
    behind=$(git rev-list "HEAD..${remote_branch}" 2>/dev/null | wc -l | tr -d ' ')

    if [ "${ahead}" -gt 0 ]; then
      echo " ${_git_sep}  Can Be Pushed(${ahead})"
    elif [ "${behind}" -gt 0 ]; then
      echo " ${_git_sep}  Can Be Pulled"
    fi
  else
    # リモートブランチがない場合、origin/HEADからの差分を表示
    local commits=$(git rev-list origin/HEAD..HEAD 2>/dev/null | wc -l | tr -d ' ')
    if [ "${commits}" -gt 0 ]; then
      echo " ${_git_sep}  Unpushed Branch(${commits})"
    else
      echo " ${_git_sep}  Unpushed Branch"
    fi
  fi
}

function update_git_info() {
  LANG=en_US.UTF-8 vcs_info
  local vcs_info=${vcs_info_msg_0_}

  if [ -n "${vcs_info}" ]; then
    local git_status=$(_git_status_info)
    local bg_color=034
    local fg_color=016

    if [ -n "${git_status}" ]; then
      bg_color=184
      fg_color=016
    fi

    if [[ -n $(echo ${vcs_info} | grep -Ei "merge|unstaged|staged" 2> /dev/null) ]]; then
        bg_color=196
        fg_color=255
    fi

    echo "%{\e[48;5;${bg_color}m%}%{\e[38;5;063m%}${_git_corner}%{\e[m%}%{\e[48;5;${bg_color}m%} %{\e[38;5;${fg_color}m%}${vcs_info}${git_status} %{\e[m%}%{\e[m%}%{\e[48;5;238m%}%{\e[38;5;${bg_color}m%}${_git_corner}%{\e[m%}%{\e[m%}"
  else
    echo -n "%{\e[48;5;238m%}%{\e[38;5;063m%}${_git_corner}%{\e[m%}%{\e[m%}"
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
    #   256COLORSチートシート: https://jonasjacek.github.io/colors
    case `uname` in
      Darwin)
        prompt_host=$'%{\e[48;5;063m%} %(?.%{\e[38;5;077m%}✔.%{\e[38;5;196m%}✘) %{\e[38;5;016m%}%n %{\e[m%}%{\e[m%}'
        prompt_dir=$'%{\e[48;5;238m%} %{\e[38;5;226m%} \uE5FE  %~ %{\e[m%}% %{\e[m%}'
        prompt_su=$'%(!.%{%k%F{blue}%K{black}%}\uE0B8%{%F{yellow}%} ⚡ %{%k%F{black}%}.%{\e[38;5;238m%}\uE0B8%{\e[m%})'
        prompt_shell=$'%{\e[48;5;247m%} %{\e[38;5;016m%}\uE711  %{\e[m%}%{\e[m%}%{\e[38;5;247m%}\uE0B8%{\e[m%}'
        PROMPT=$'
${prompt_host}$(update_git_info)${prompt_dir}${prompt_su}%{${reset_color}%}
${prompt_shell}  %{%f%k%b%}'
      ;;
      Linux)
        prompt_host=$'%{\e[48;5;063m%} %(?.%{\e[38;5;077m%}✔.%{\e[38;5;196m%}✘) %{\e[38;5;016m%}%n %{\e[m%}%{\e[m%}'
        prompt_dir=$'%{\e[48;5;238m%}%{\e[38;5;226m%} \uE5FE %~ %{\e[m%}% %{\e[m%}'
        prompt_su=$'%(!.%{%k%F{blue}%K{black}%}\uE0B8%{%F{yellow}%} ⚡ %{%k%F{black}%}.%{\e[38;5;238m%}◣%{\e[m%})'
        prompt_shell=$'%{\e[48;5;247m%} %{\e[38;5;016m%}\uF31B  %{\e[m%}%{\e[m%}%{\e[38;5;247m%}◣%{\e[m%}'
        PROMPT=$'
${prompt_host}$(update_git_info)${prompt_dir}${prompt_su}%{${reset_color}%}
${prompt_shell}  %{%f%k%b%}'
      ;;
      *)
        PROMPT="${green}%m${magenta}%# %{${reset_color}%}"
        PROMPT2="${white}%_>%{${reset_color}%}"
      ;;
    esac
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
