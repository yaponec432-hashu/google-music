#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Save the music archive
set -e

main() {
    zip -9 ../google-music.zip -- ./* ./.*
    local sha256
    sha256="$(sha256sum ../google-music.zip | cut -f1 -d ' ')"
    echo "${sha256}"
    mv -v ../google-music.zip "../google-music-${sha256}.zip"
}

main
