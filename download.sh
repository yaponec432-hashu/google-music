#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Download music
set -e -o pipefail

FILTER='acompressor=threshold=0.6:ratio=4:link=maximum,virtualbass'
FILTER="${FILTER},alimiter=limit=0.95"

download() {
    local file_name="${1}"
    local link="${2}"

    [[ -f "${file_name}.ogg" ]] && return
    yt-dlp "${link}" -f 251/140/ba --cookies "${HOME}/cookies" -r 1M \
        --min-sleep-interval 15 --max-sleep-interval 30 --xff jp -o - \
        | ffmpeg -v 24 -stats -y -i - -vn -c:a libopus -vbr on -b:a 128k \
        -af "${FILTER}" -- "./${file_name}.ogg"
}

main() {
    chmod 600 "${HOME}/cookies"
    [[ -n "${1}" ]] && yt-dlp --update-to nightly
    local file_name
    local link
    tail -n +2 download-list.csv | while IFS=',' read -r file_name link; do
        download "${file_name}" "${link}"
    done
}

main "${1}"
