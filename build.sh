#!/bin/sh

set -e

GHC_VERSION="$(stack ghc -- --numeric-version)"
RTS_VERSION="1.0.2"
PROGRAMS_PATH="$(stack path --programs)"
TARGET="$(basename "$PROGRAMS_PATH")"
RTS_STATIC_PATH="$PROGRAMS_PATH/ghc-tinfo6-$GHC_VERSION/lib/ghc-$GHC_VERSION/lib/$TARGET-ghc-$GHC_VERSION/rts-$RTS_VERSION/libHSrts-$RTS_VERSION.a"

echo "GHC version: $GHC_VERSION"
echo "RTS path: $RTS_STATIC_PATH"

stack ghc -- \
	-static \
	-shared \
	-no-hs-main \
	-Wall \
	-DNAPI_VERSION=4 \
	src/Test.hs \
	src/*.c \
	-isrc \
	-Inode_modules/node-api-headers/include \
	-hidir inter \
	-odir inter \
	-package ghc \
	-lHSrts-1.0.2 \
	-o haskell.node

rm -r inter

echo Done
