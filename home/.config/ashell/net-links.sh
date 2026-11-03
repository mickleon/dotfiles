#!/bin/bash

filter='
    [.[] | select(.flags | index("POINTOPOINT")) | .ifname]
    | {text: join("  "), alt: (if length > 0 then "up" else "down" end)}
'

last=

print_links() {
    local out
    out=$(ip -j link show | jq -c "$filter") || return
    if [[ $out != "$last" ]]; then
        printf '%s\n' "$out"
        last=$out
    fi
}

print_links
ip monitor link | while read -r _; do
    print_links
done
