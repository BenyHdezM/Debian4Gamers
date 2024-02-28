#! /usr/bin/env bash


existing_keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
next_index=$(($(echo "$existing_keybindings" | grep -oP 'custom[0-9]+' | grep -oP '[0-9]+' | sort -rn | head -n1) + 1))
new_binding="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$next_index/"

# Step 2: Set properties for the new custom keybinding
custom_keybindings_array=$(echo "$existing_keybindings" | tr -d "[]")
custom_keybindings_array="${custom_keybindings_array}, '${new_binding}'"

# Step 2: Set properties for the new custom keybinding
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[${custom_keybindings_array}]"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$next_index/ name 'Instant Replay on/off'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$next_index/ command '/home/beny/.config/gpu-screen-recorder/start-replay.sh'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$next_index/ binding '<Shift><Alt>F9'


existing_keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
next_index=$(($(echo "$existing_keybindings" | grep -oP 'custom[0-9]+' | grep -oP '[0-9]+' | sort -rn | head -n1) + 1))
new_binding="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$next_index/"

# Step 2: Set properties for the new custom keybinding
custom_keybindings_array=$(echo "$existing_keybindings" | tr -d "[]")
custom_keybindings_array="${custom_keybindings_array}, '${new_binding}'"
# Step 2: Set properties for the new custom keybinding
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[${custom_keybindings_array}]"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$next_index/ name 'Instant Replay Save Replay'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$next_index/ command '/home/beny/.config/gpu-screen-recorder/save-replay.sh'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$next_index/ binding '<Shift><Alt>F10'