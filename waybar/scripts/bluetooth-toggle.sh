#!/bin/bash
POWERED=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
if [ "$POWERED" = "yes" ]; then
    bluetoothctl power off
else
    bluetoothctl power on
fi
