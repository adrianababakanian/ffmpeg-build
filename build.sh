#!/bin/bash -eu

case "$1" in
  *-apple-darwin )
    ADDITIONAL_ARGS=
    ;;
  *-unknown-linux-gnu )
    ADDITIONAL_ARGS=
    ;;
  *-unknown-linux-musl )
    ADDITIONAL_ARGS="--cc=musl-gcc --ld=musl-ld"
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
  --prefix="$2" \
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

# builds libavutil, livavcodec, and libavformat
make

# install to $2
make install
