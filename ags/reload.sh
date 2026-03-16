#!/usr/bin/env bash

export GI_TYPELIB_PATH="/usr/local/lib64/girepository-1.0${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}"
export LD_LIBRARY_PATH="/usr/local/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

AGS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ags quit 2>/dev/null
sleep 0.3
ags run --directory "$AGS_DIR" &
