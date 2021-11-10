#!/bin/bash -eu
die() {
  echo "$@" >&2
  exit 1
}

run_root() {
  if [ "$(id -u)" == 0 ]; then
    "$@"
  elif sudo --help 2>&1 >/dev/null; then
    sudo "$@"
  else
    die "you are not root and no sudo command found."
  fi
}

run_apt() {
  run_root apt "$@"
}

case "$1" in
  *-apple-darwin )       brew update && brew install automake git libtool shtool wget nasm ;;
  *-pc-windows-msvc )    choco install -y msys2 yasm;;
  *-unknown-linux-* )
    packages="autoconf automake build-essential git-core wget yasm"
    case "$1" in
      x86_64-* ) packages="$packages build-essential-amd64" ;;
      aarch64-* ) packages="$packages build-essential-arm64" ;;
    esac
    case "$1" in
      x86_64-*-musl ) packages="$packages musl-tools" ;;
      aarch64-*-musl ) packages="$packages musl-tools:arm64" ;;
    esac
    run_apt update -qq && run_apt install -y $packages;;
esac
