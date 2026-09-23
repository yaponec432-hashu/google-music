#!/data/data/com.termux/files/usr/bin/env python3
# SPDX-License-Identifier: 0BSD
"""Sort the download list."""

from csv import writer, reader


def main() -> None:
    file_name = "download-list.csv"
    with open(file_name, "r", newline="") as file:
        rows = list(reader(file))

    header = rows[0]
    data = rows[1:]
    data.sort()

    with open(file_name, "w",newline="") as file:
        write = writer(file, lineterminator="\n")
        write.writerow(header)
        write.writerows(data)


if __name__ == "__main__":
    main()
