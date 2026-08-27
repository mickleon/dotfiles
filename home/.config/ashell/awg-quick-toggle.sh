#!/bin/bash

if pgrep -f amneziawg >/dev/null; then
    sudo -A /usr/bin/awg-quick down awg0
else
    sudo -A /usr/bin/awg-quick up awg0
fi
