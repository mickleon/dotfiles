#!/bin/bash
# Выводит состояние NumLock в формате CustomModule ashell.
# Состояние берётся из Hyprland (основная клавиатура в `hyprctl devices`).
# Событий об изменении NumLock Hyprland не шлёт, поэтому состояние опрашивается
# раз в 0.5 с, а строка печатается только при изменении.

last=

while :; do
    state=$(hyprctl devices -j 2>/dev/null |
        jq -r '[.keyboards[] | select(.main)][0].numLock
               | if . == true then "on" elif . == false then "off" else empty end')

    if [[ -n $state && $state != "$last" ]]; then
        if [[ $state == "on" ]]; then
            text="NL"
        else
            text=""
        fi
        printf '{"text":"%s","alt":"%s","tooltip":"NumLock %s"}\n' "$text" "$state" "$state"
        last=$state
    fi

    sleep 0.5
done
