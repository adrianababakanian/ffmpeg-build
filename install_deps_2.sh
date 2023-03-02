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
  *-apple-darwin )
    brew update && brew install automake git libtool shtool wget nasm
    resources="$(dirname "$0")/resources/aarch64-apple-darwin"
    run_root mkdir -p "/usr/local/bin"
    run_root cp -p "$resources/aarch64-apple-darwin-clang" "/usr/local/bin/aarch64-apple-darwin-clang"
    ;;
  *-pc-windows-msvc )
    pacman -S --noconfirm git make nasm
    curl -sL https://github.com/FFmpeg/gas-preprocessor/raw/master/gas-preprocessor.pl > /usr/bin/gas-preprocessor.pl
    ;;
  *-unknown-linux-* )
    packages="autoconf automake git-core wget yasm"
    case "$1" in
      x86_64-* ) packages="$packages build-essential" ;;
      aarch64-* ) packages="$packages crossbuild-essential-arm64" ;;
    esac
    case "$1" in
      x86_64-*-musl ) packages="$packages musl-tools" ;;
      aarch64-*-musl )
        # add arm to sources and install musl-dev
        run_root dpkg --add-architecture arm64
        release="$(bash -c '. /etc/os-release; echo $VERSION_CODENAME')"
        echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ $release universe" | run_root tee -a /etc/apt/sources.list > /dev/null
        echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ $release main" | run_root tee -a /etc/apt/sources.list > /dev/null
        packages="$packages musl-dev:arm64"

        # install musl-gcc and specs
        resources="$(dirname "$0")/resources/aarch64-linux-musl"
        musl_lib="/usr/lib/aarch64-linux-musl"
        run_root mkdir -p "$musl_lib"
        run_root cp --preserve=mode "$resources/musl-gcc.specs" "$musl_lib/musl-gcc.specs"
        run_root cp --preserve=mode "$resources/aarch64-linux-musl-gcc" "/usr/bin/aarch64-linux-musl-gcc"
        ;;
    esac
    run_apt update -qq || :
    run_apt install -y $packages;;
esac
