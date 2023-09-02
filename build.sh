#!/bin/sh

set -e

GHC_VERSION="$(stack ghc -- --numeric-version)"

echo "GHC version: $GHC_VERSION"

stack ghc -- \
	-static \
	-shared \
	-no-hs-main \
	-Wall \
	-DNAPI_VERSION=4 \
	src/Test.hs \
	src/*.c \
	-Inode_modules/node-api-headers/include \
	-hidir inter \
	-odir inter \
	-package ghc \
	-lHSrts-1.0.2 \
	-o haskell.node

rm -r inter

echo Done
