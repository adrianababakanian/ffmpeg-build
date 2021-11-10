#!/bin/bash
die() {
  echo "$@" >&2
  exit 1
}

run_apt() {
  if [ "$(id -u)" == 0 ]; then
    apt "$($@)"
  elif sudo --help 2>&1 >/dev/null; then
    sudo -- apt "$($@)"
  else
    die "you are not root and no sudo command found."
  fi
}

case "$1" in
  *-apple-darwin )       brew update && brew install autoconf automake build-essential git-core wget yasm ;;
  *-unknown-linux-gnu )  run_apt update -qq && run_apt -y install autoconf automake build-essential git-core wget yasm;;
  *-unknown-linux-musl ) run_apt update -qq && run_apt -y install autoconf automake build-essential git-core musl-tools wget yasm;;
  *-pc-windows-msvc )    choco install msys2 yasm;;
esac
