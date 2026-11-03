#!/bin/bash

if [ -d /sys/class/net/awg0 ]; then
    sudo -A /usr/bin/awg-quick down awg0
else
    sudo -A /usr/bin/awg-quick up awg0
fi
