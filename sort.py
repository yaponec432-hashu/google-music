#!/data/data/com.termux/files/usr/bin/env python3
# SPDX-License-Identifier: 0BSD
"""Sort the contents of files."""

from pathlib import Path


def sort_content(file_name: str) -> None:
    path = Path(file_name)
    with path.open("r", encoding="utf-8") as file:
        header, *lines = file.readlines()
    lines.sort()
    with path.open("w", encoding="utf-8") as file:
        file.write(header)
        file.writelines(lines)


def main() -> None:
    for file in ("download-list.csv", "playlist.m3u8"):
        sort_content(file)


if __name__ == "__main__":
    main()
    
