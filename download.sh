#!/data/data/com.termux/files/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
# Download the music

# Reduce the ear fatigue
FILTER='virtualbass,pan=stereo|FL=FL+LFE|FR=FR+LFE,equalizer=f=3500:t=h:w=3000'
FILTER="${FILTER}:g=-10,highpass=f=80,crossfeed,alimiter=limit=0.95"
FILTER="${FILTER},loudnorm=lra=50:tp=-9:i=-28"

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

    local data
    data="$(ffmpeg -hide_banner -i ${temp_file} \
        -af ebur128=framelog=quiet:peak=true -f null - 2>&1)"

    local i tp lra threshold
    i=$(echo "${data}" | grep 'I: .* LUFS$' | awk '{print $2}')
    tp=$(echo "${data}" | grep 'Peak: .* dBFS$' | awk '{print $2}')
    lra=$(echo "${data}" | grep 'LRA: .* LU$' | awk '{print $2}')
    threshold=$(echo "${data}" | grep 'Threshold: .* LUFS$' | awk '{print $2}')

    local filter
    filter="${FILTER}:measured_I=${i}:measured_TP=${tp}:measured_LRA=${lra}"
    filter="${filter}:measured_thresh=${threshold}"

    ffmpeg -v 24 -stats -y -i "${temp_file}" -vn -c:a aac -b:a 128k \
        -af "${filter}" -ar 44100 -- "${output_file}"
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
