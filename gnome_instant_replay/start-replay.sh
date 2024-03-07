\#!/bin/sh

video_path="$HOME/Videos"
seconds=180

if pgrep -x "gpu-screen-reco" >/dev/null; then
	killall -SIGINT gpu-screen-recorder
	# notify-send -u normal -t 1000 "GPU Instant Replay" "Instant Replay $window_name has stopped"
	zenity --window-icon="$window_icon" --warning --text="Instant Replay is no longer active." --timeout=1 --no-markup
else
	window=$(xdotool selectwindow)
	echo $window
	if [ -n "$window" ]; then
		window_name=$(xdotool getwindowclassname "$window" || xdotool getwindowname "$window" || echo "game")
		window_icon=$(xprop -id $window | awk -F '"' '/WM_ICON/{print $2}' | tail -n 1)
		# notify-send -u normal -t 1000 "GPU Instant Replay" "Instant Replay $window_name has started" -i "$window_icon"
		zenity --window-icon="$window_icon" --warning --text="Instant Replay $window_name has begun" --timeout=1 --no-markup
		window_id=$(xdotool search --onlyvisible --class "zenity" | tail -1)

		# Move the window to the top of the screen
		xdotool windowmove $window_id 0 0
		/usr/bin/flatpak run --command=gpu-screen-recorder com.dec05eba.gpu_screen_recorder -w "$window" -f $seconds -a "$(pactl get-default-sink).monitor|$(pactl get-default-source)" -c mp4 -r 60 -o "$HOME/Videos/$window_name"
	fi
fi
