#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Update the m3u8 file
set -e

main() {
    echo '#EXTM3U' > ./playlist.m3u8
    ls ./*.ogg >> ./playlist.m3u8
}

main
