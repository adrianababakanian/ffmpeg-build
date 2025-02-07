#!/bin/bash -eu

case "$1" in
  aarch64-apple-darwin )
    ADDITIONAL_ARGS="--cc=aarch64-apple-darwin-clang"
    ;;
  *-apple-darwin )
    ADDITIONAL_ARGS="--cc=clang"
    ;;
  aarch64-unknown-linux-gnu )
    # for aarch64 gnu, prefix is required
    ADDITIONAL_ARGS="--cross-prefix=aarch64-linux-gnu- --target-os=linux"
    ;;
  *-unknown-linux-gnu )
    ADDITIONAL_ARGS=
    ;;
  aarch64-unknown-linux-musl )
    # for aarch64 musl, musl-gcc for aarch64
    ADDITIONAL_ARGS="--cc=aarch64-linux-musl-gcc"
    ;;
  *-unknown-linux-musl )
    ADDITIONAL_ARGS="--cc=musl-gcc"
    ;;
  *-pc-windows-msvc )
    ADDITIONAL_ARGS=--toolchain=msvc
    ;;
esac

case "$1" in
  aarch64-* )
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --enable-cross-compile --arch=aarch64"
    ;;
esac

./configure \
  --disable-doc \
  --disable-programs \
  --disable-avdevice \
  --disable-swresample \
  --disable-swscale \
  --disable-postproc \
  --disable-avfilter \
  --disable-network \
  --disable-encoders \
  --disable-decoders \
  --disable-hwaccels \
  --disable-protocols \
  --disable-filters \
  --enable-protocol=file \
  $ADDITIONAL_ARGS \
