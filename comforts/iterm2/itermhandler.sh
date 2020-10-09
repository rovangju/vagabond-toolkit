#!/usr/bin/env bash
file="$1"
line_number="${2:-}"
if [[ -f "$file" ]]; then
    printf "vim ${line_number:++}${line_number} %q\n" "$file"
else
    printf "cd %q\n" "${file}"
    printf "ls -lah\n"	
fi
