
## emacsの一括バイトコンパイル
function batchcompile() {
  for i in ${@}; do;
    # echo $i
    emacs -batch -f batch-byte-compile ${i}
  done;
}

## ターミナル上の現在のディレクトリをdired で開く
## Invoke the ``dired'' of current working directory in Emacs buffer.
function e() {
  case "${OSTYPE}" in
    linux*)
      emacsclient -e "(dired \"${1:a}\")"
    ;;
    darwin*)
      echo "chdir to ${PWD}"
      /usr/local/bin/emacsclient -e "(dired \"${1:a}\")"
    ;;
  esac
}

## Emacs の現在のバッファに対応するディレクトリをターミナル上の zsh で開く
## Chdir to the ``default-directory'' of currently opened in Emacs buffer.
function t() {
  local emacs_cwd
  case "${OSTYPE}" in
    linux*)
      emacs_cwd=`emacsclient -e "
        (if (featurep 'elscreen)
            (elscreen-current-directory)
          (non-elscreen-current-directory))" | sed 's/^"\(.*\)"$/\1/'`
      # emacs_cwd=`emacsclient -e "(current-directory-to-terminal))" | sed 's/^"\(.*\)"$/\1/'`
    ;;
    darwin*)
      emacs_cwd=`/usr/local/bin/emacsclient -e "
        (if (featurep 'elscreen)
            (elscreen-current-directory)
          (non-elscreen-current-directory))" | sed 's/^"\(.*\)"$/\1/'`
      # emacs_cwd=`/usr/local/bin/emacsclient -e "(current-directory-to-terminal)" | sed 's/^"\(.*\)"$/\1/'`
    esac

  echo "chdir to ${emacs_cwd}"
  cd "${emacs_cwd}"
}
