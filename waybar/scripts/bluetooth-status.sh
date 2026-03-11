#!/bin/bash
POWERED=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
if [ "$POWERED" = "yes" ]; then
    DEVICE=$(bluetoothctl info 2>/dev/null | grep "Name:" | head -1 | sed 's/.*Name: //')
    if [ -n "$DEVICE" ]; then
        echo "{\"text\": \"  $DEVICE\", \"class\": \"connected\", \"tooltip\": \"Connected: $DEVICE\"}"
    else
        echo "{\"text\": \"  On\", \"class\": \"on\", \"tooltip\": \"Bluetooth on\"}"
    fi
else
    echo "{\"text\": \"  Off\", \"class\": \"off\", \"tooltip\": \"Bluetooth off\"}"
fi
