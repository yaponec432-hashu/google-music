#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Download the music

FILTER='equalizer=f=3500:t=h:w=3000:g=-10,crossfeed,virtualbass'
FILTER="${FILTER},pan=stereo|FL=FL+LFE|FR=FR+LFE,highpass=f=80"
FILTER="${FILTER},alimiter=limit=0.95,volume=0.05"

download() {
    local file_name="${1/,*}"
    local link="${1#*,}"

    local output_file="./${file_name}.m4a"
    [[ -f "${output_file}" ]] && return
    echo "Downloading ${file_name}"

    local temp_file="${TMPDIR}/google-music-temp.m4a"
    yt-dlp "${link}" -f 140 --cookies "${HOME}/cookies" \
        --min-sleep-interval 1 --max-sleep-interval 3 --embed-metadata \
        --force-overwrites -o "${temp_file}"

    ffmpeg -v 24 -stats -y -i "${temp_file}" -vn -c:a aac \
        -af "${FILTER}" -- "${output_file}"
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
