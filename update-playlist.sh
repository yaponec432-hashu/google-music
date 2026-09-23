#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Update the playlist file
set -e

main() {
    local playlist='./playlist.m3u8'
    echo '#EXTM3U' > "${playlist}"
    ls ./*.ogg >> "${playlist}"
}

main
