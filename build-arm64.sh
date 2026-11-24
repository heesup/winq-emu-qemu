#!/bin/bash
# Build WINQ-EMU QEMU for Windows on ARM in the MSYS2 CLANGARM64 environment.
# Prerequisites:
#   pacman -S git diffutils make mingw-w64-clang-aarch64-{clang,lld,meson,ninja,pkgconf,glib2,pixman,sdl2-compat,libepoxy,python,dtc,zstd,libslirp}
# and winq-emu-virglrenderer built for CLANGARM64 and installed to $PREFIX
# (or with its pkg-config dir on PKG_CONFIG_PATH).
set -e
PREFIX=${PREFIX:-/clangarm64}
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
mkdir -p build-arm64
cd build-arm64
# --disable-guest-agent: qga needs windmc, which CLANGARM64 doesn't ship.
../configure \
    --target-list=aarch64-softmmu \
    --prefix="$PREFIX" \
    --enable-whpx \
    --enable-opengl \
    --enable-virglrenderer \
    --enable-slirp \
    --enable-sdl \
    --disable-docs \
    --disable-plugins \
    --disable-guest-agent \
    2>&1
ninja qemu-system-aarch64.exe qemu-system-aarch64w.exe qemu-img.exe
