#!/bin/sh

set -e

GHC_VERSION="$(ghc -- --numeric-version)"

echo "GHC version: $GHC_VERSION"

ghc \
	-dynamic \
	-shared \
	-fPIC \
	-no-hs-main \
	-Wall \
	-cpp \
	hyphen/lowlevel_src/Hyphen.hs \
	hyphen/lowlevel_src/hyphen_c.c \
	-ihyphen/lowlevel_src \
	-hidir inter \
	-odir inter \
	-I/usr/include/python3.11 \
	-package ghc \
	-lHSrts-1.0.2-ghc"$GHC_VERSION" \
	-lpython3.11 \
	-optl -Wl,--version-script=hyphen/hslowlevel.version,-L/usr/lib \
	-o hyphen/hslowlevel.cpython-311-x86_64-linux-gnu.so
rm -r inter

echo Done
