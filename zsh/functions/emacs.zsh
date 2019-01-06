
## emacsの一括バイトコンパイル
function batchcompile() {
  for i in $@; do;
    # echo $i
    emacs -batch -f batch-byte-compile $i
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
      echo "chdir to $PWD"
      /usr/local/bin/emacsclient -e "(dired \"${1:a}\")"
    ;;
  esac
}

## Emacs の現在のバッファに対応するディレクトリをターミナル上の zsh で開く
## Chdir to the ``default-directory'' of currently opened in Emacs buffer.
function t() {
  case "${OSTYPE}" in
    linux*)
      EMACS_CWD=`emacsclient -e "
        (if (featurep 'elscreen)
            (elscreen-current-directory)
          (non-elscreen-current-directory))" | sed 's/^"\(.*\)"$/\1/'`
      # EMACS_CWD=`emacsclient -e "(current-directory-to-terminal))" | sed 's/^"\(.*\)"$/\1/'`
    ;;
    darwin*)
      EMACS_CWD=`/usr/local/bin/emacsclient -e "
        (if (featurep 'elscreen)
            (elscreen-current-directory)
          (non-elscreen-current-directory))" | sed 's/^"\(.*\)"$/\1/'`
      # EMACS_CWD=`/usr/local/bin/emacsclient -e "(current-directory-to-terminal)" | sed 's/^"\(.*\)"$/\1/'`
    esac

  echo "chdir to $EMACS_CWD"
  cd "$EMACS_CWD"
}
