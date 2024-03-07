#!/bin/sh -e
if pgrep -x "gpu-screen-reco" >/dev/null; then
    killall -SIGUSR1 gpu-screen-recorder
    # notify-send -u critical "GPU Instant Replay" "Instant Replay saved"
    zenity --window-icon="$window_icon" --warning --text="Your Instant Replay has been saved." --timeout=2 --no-markup
fi
