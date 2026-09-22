#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Play music
set -e

main() {
    mpv --ao=opensles --opensles-buffer-size-in-ms=500 --no-config \
        --audio-pitch-correction=no --no-video --no-input-default-bindings \
        --gapless-audio=no --shuffle \
        -- "${HOME}/storage/downloads/google-music/playlist.m3u8"
}

main
