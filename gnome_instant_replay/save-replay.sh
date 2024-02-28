#!/bin/sh -e
if pgrep -x "gpu-screen-reco" >/dev/null; then
    killall -SIGUSR1 gpu-screen-recorder
    notify-send "GPU Instant Replay" "Instant Replay saved"
fi
