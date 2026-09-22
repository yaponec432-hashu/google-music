#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Save the music archive
set -e

main() {
    zip -0 ../google-music.zip -- ./* ./.*
}

main
