#!/bin/bash

if pgrep -f "gpu-screen-recorder" >/dev/null; then
    pkill -f "gpu-screen-recorder"
else
    gpu-screen-recorder -w eDP-1 -c mp4 -k h264 -ac opus -f 30 -cursor yes -restore-portal-session yes -cr limited -encoder gpu -o "/home/mleontyev/Videos/Записи экрана/Video_$(date +"%Y-%m-%d_%H-%M-%S").mp4" -q very_high -a device:default_output
fi
