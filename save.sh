#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Archive the music
set -e

main() {
    local archive='../google-music.zip'
    zip -9r "${archive}" -- .
    local hash
    hash="$(sha256sum ${archive} | cut -f1 -d ' ')"
    mv -v "${archive}" "../google-music-${hash}.zip"
}

main
