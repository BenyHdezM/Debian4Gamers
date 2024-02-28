#!/bin/sh

video_path="$HOME/Videos"
seconds=60

if pgrep -x "gpu-screen-reco" >/dev/null; then
  killall -SIGINT gpu-screen-recorder
  notify-send "GPU Instant Replay" "Instant Replay has stopped"
else
  notify-send "GPU Instant Replay" "Instant Replay has started"
  /usr/bin/flatpak run --command=gpu-screen-recorder com.dec05eba.gpu_screen_recorder -w screen -f $seconds -a "$(pactl get-default-sink).monitor|$(pactl get-default-source)" -r 30 -c mp4 -o "$video_path"
fi
