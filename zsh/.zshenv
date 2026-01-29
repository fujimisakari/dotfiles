
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
###  Enviroment Setting
###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

case "${OSTYPE}" in
  linux*)
    PATH=${HOME}/.local/bin:${HOME}/dotfiles/bin:/sbin:/usr/sbin:${PATH}
  ;;
  darwin*)
    export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}
    PATH=/usr/local/opt/coreutils/libexec/gnubin:${HOME}/dotfiles/bin:/opt/homebrew/bin:/usr/local/bin:/sbin:/usr/sbin:/Applications/Emacs.app/Contents/MacOS/bin:${PATH}
    if [[ -e "/usr/local/opt/llvm/bin" ]]; then
      PATH=/usr/local/opt/llvm/bin:${PATH}
    fi
    if [[ -e "/opt/homebrew/share/google-cloud-sdk/bin" ]]; then
      PATH=/opt/homebrew/share/google-cloud-sdk/bin:${PATH}
    fi
    if [[ -e "/opt/homebrew/opt/openjdk/bin" ]]; then
      PATH=/opt/homebrew/opt/openjdk/bin:${PATH}
    fi
  ;;
esac

## Python
export PYTHONDONTWRITEBYTECODE=1  # pycは作らない
export WERKZEUG_DEBUG_PIN='off'   # for Django-extentions

if [[ -e "${HOME}/.pyenv" ]]; then
  export PYENV_ROOT=${HOME}/.pyenv
  PATH=${PYENV_ROOT}/bin:${PATH}
  eval "$(pyenv init -)"
fi

## PHP
if [[ -e "${HOME}/.phpenv" ]]; then
  PATH=${HOME}/.phpenv/bin:${PATH}
  eval "$(phpenv init -)"
fi

## Ruby
if [[ -e "${HOME}/.rbenv" ]]; then
  PATH=${HOME}/.rbenv/bin:${PATH}
  eval "$(rbenv init -)"
fi

## node.js
if [[ -e "${HOME}/.nodebrew" ]]; then
  PATH=${HOME}/.nodebrew/current/bin:${PATH}
fi

## Go
case "${OSTYPE}" in
  linux*)
    if [[ -s "/usr/local/go" ]]; then
      PATH=/usr/local/go/bin:${PATH}
    fi
    if [[ -s "${HOME}/go" ]]; then
      export GOPATH=${HOME}/go
      PATH=${HOME}/go/bin:${PATH}
    fi
  ;;
  darwin*)
    if [[ -s "${HOME}/projects/merpay/go" ]]; then
      export GOPATH=${HOME}/projects/merpay/go
      PATH=/usr/local/go/bin:${HOME}/dev/go/bin:${HOME}/projects/merpay/go/bin:${PATH}
    fi
  ;;
esac

if [[ -e "${HOME}/.goenv" ]]; then
  export GOENV_DISABLE_GOPATH=1
  PATH=${HOME}/.goenv/bin:${PATH}
  eval "$(goenv init -)"
fi

## direnv
if which direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

## Common Lisp
if [[ -e "${HOME}/.roswell" ]]; then
  PATH=${HOME}/.roswell/bin:${PATH}
fi

## Elixir
if [[ -e "${HOME}/.exenv" ]]; then
  PATH=${HOME}/.exenv/bin:${PATH}
  eval "$(exenv init -)"
fi

## GITHUB MCP で利用している
export GITHUB_TOKEN=$(gh auth token 2>/dev/null)

## カラー設定
if [ -e "${HOME}/.dircolors" ]; then
  if type dircolors > /dev/null 2>&1; then
    eval "$(dircolors ~/.dircolors)"
  elif type gdircolors > /dev/null 2>&1; then
    eval "$(gdircolors ~/.dircolors)"
  fi
fi

## screen セッション保存Dir
export SCREENDIR=${HOME}/.screens

## screeninator
[[ -e "${HOME}/.screeninator/screeninator" ]] && source ${HOME}/.screeninator/screeninator

## HOMEBREW CASKのインストール先
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

## エディタの指定
export EDITOR='vim'

## PAGER設定
if [ -x /usr/bin/lv ]; then
  export PAGER='lv'
fi

## ロケール設定
export LANG='ja_JP.UTF-8'
export LC_ALL="${LANG}"

## 補完リストが多いときに尋ねる数
## -1 : 尋ねない
##  0 : ウィンドウから溢れるときは尋ねる
export LISTMAX=0

## LIBRARY_PATHを設定する
## 警告が多く出る原因の一つとして、libgccjitが正しくリンクされていないことも考えられます。以下のコマンドでLIBRARY_PATHを設定し、Emacsの起動時に適切なライブラリを読み込ませると警告が減ることがあります。
if [ -e "/opt/homebrew" ]; then
  export LIBRARY_PATH=/opt/homebrew/lib/gcc/$(brew list gcc | grep 'libgccjit.so' | sed 's/.*libgccjit.so.//')
fi

