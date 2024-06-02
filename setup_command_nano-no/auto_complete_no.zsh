#!/bin/zsh

autoload -Uz compinit
compinit

typeset -ga words=("$@")

function flags() {
  local check=true
  local -a descriptions values

  for word in "${words[@]}"; do
    if [[ $word == '-f' || $word == '-s' ]]; then
      check=false
      break
    fi
  done

  if $check; then
    # shellcheck disable=SC2034
    descriptions=(
      '-f: find file'
      '-s: search string in file'
    )

    # shellcheck disable=SC2034
    values=(
      '-f'
      '-s'
    )

    compadd -d descriptions -a "values"
  fi
}

compdef flags no
