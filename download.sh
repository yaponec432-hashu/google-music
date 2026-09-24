#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Download the music
set -e -o pipefail

FILTER='bass=g=6,equalizer=f=3500:t=h:w=3000:g=-10,crossfeed,loudnorm'
FILTER="${FILTER}=stats_file=-:print_format=json"

download() {
    local temp_file="${TMPDIR}/google-music-temp.m4a"
    local file_name="${1/,*}"
    local link="${1#*,}"

    [[ -f "${file_name}.ogg" ]] && return
    echo "Downloading ${file_name}"
    yt-dlp "${link}" -f 140/ba --cookies "${HOME}/cookies" \
        --min-sleep-interval 3 --max-sleep-interval 5 --embed-metadata \
        --force-overwrites -o "${temp_file}"

    local data
    data="$(ffmpeg -v 24 -stats -i ${temp_file} -vn -af ${FILTER} \
        -f null -- - \
        | sed -n '/{/,/}/p' | tr -d '":,' | awk '{print $2}')"

    local i
    local tp
    local lra
    local thresh
    i=$(echo "${data}" | sed -n 2p)
    tp=$(echo "${data}" | sed -n 3p)
    lra=$(echo "${data}" | sed -n 4p)
    thresh=$(echo "${data}" | sed -n 5p)

    local measured
    measured="${FILTER}:measured_i=${i}:measured_tp=${tp}:measured_lra=${lra}"
    measured="${measured}:measured_thresh=${thresh}"

    ffmpeg -v 24 -stats -y -i "${temp_file}" -vn -c:a aac -b:a 128k \
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
