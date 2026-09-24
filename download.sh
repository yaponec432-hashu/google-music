#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Download music
set -eu -o pipefail

FILTER='bass=g=6,equalizer=f=3500:t=h:w=3000:g=-10,crossfeed,loudnorm'
FILTER="${FILTER}=stats_file=-:print_format=json"
TEMP_FILE="${TMPDIR}/google-music-temp.m4a"

download() {
    local file_name="${1/,*}"
    local link="${1#*,}"

    [[ -f "${file_name}.ogg" ]] && return
    echo "Downloading ${file_name}"
    yt-dlp "${link}" -f 140 --cookies "${HOME}/cookies" \
        --min-sleep-interval 3 --max-sleep-interval 5 --embed-metadata \
        --force-overwrites -o "${TEMP_FILE}"

    local json
    json="$(ffmpeg -v 24 -stats -i ${TEMP_FILE} -vn -af ${FILTER} \
        -f null -- - \
        | sed -n '/{/,/}/p' | tr -d '":,' | awk '{print $2}')"

    local i
    local tp
    local lra
    local thresh
    i=$(echo "${json}" | sed -n 2p)
    tp=$(echo "${json}" | sed -n 3p)
    lra=$(echo "${json}" | sed -n 4p)
    thresh=$(echo "${json}" | sed -n 5p)

    local measured
    measured="${FILTER}:measured_i=${i}:measured_tp=${tp}:measured_lra=${lra}"
    measured="${measured}:measured_thresh=${thresh}"

    ffmpeg -v 24 -stats -y -i "${TEMP_FILE}" -vn -c:a aac -b:a 128k \
        -af "${measured}" -- "./${file_name}.m4a"
}

main() {
    [[ -n "${1}" ]] && yt-dlp --update-to nightly
    local list
    list="$(tail -n +2 ./download-list.csv)"
    local song
    for song in ${list}; do
        download "${song}"
    done
}

main "${1}"
