#! /usr/bin/env bash

upgradeSystem() {
    ###############################################################################
    #                   Updating all the system                                   #
    ###############################################################################
    sudo rm /etc/apt/sources.list
    sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/stable_sources.list -O /etc/apt/sources.list

    print_log "\n###############################################################
##    Upgrading the entire system preparation...             ##
###############################################################\n"
    sudo apt update
    sudo dpkg --add-architecture i386 #Add x86 Architecture (Needed for Steam-Installer)
    sudo apt dist-upgrade -y
    sudo apt autoremove -y
}

vaapiOnFirefox() {
    # Define the preference setting
    PREFERENCE_SETTING='user_pref("media.ffmpeg.vaapi.enabled", true);'

    # Path to the Firefox preferences file
    PREFS_FILE="$HOME/.mozilla/firefox/*.default/prefs.js"

    # Check if the preferences file exists
    if [ -f "$PREFS_FILE" ]; then
        # Update the preference setting in the Firefox preferences file
        sed -i "/media.ffmpeg.vaapi.enabled/c\\$PREFERENCE_SETTING" "$PREFS_FILE"
    fi
}

installDependencies() {
    print_log "\n###############################################################
##                Installing Dependencies                    ##
###############################################################\n"
    sudo apt install -y nala bpytop neofetch git mesa-opencl-icd bash-completion vulkan-tools firmware-linux firmware-linux-free firmware-linux-nonfree firmware-amd-graphics pulseaudio-utils libnotify-bin libzstd-dev python3.11-venv zenity
    sudo apt install -y lm-sensors gnome-shell-extension-dashtodock gnome-shell-extension-appindicator
    # Packages for compiling CoreCtrl
    sudo apt install cmake extra-cmake-modules libquazip1-qt5-dev libspdlog-dev qttools5-dev qtdeclarative5-dev libqt5charts5-dev libqt5svg5-dev libbotan-2-dev libqca-qt5-2-dev libdrm-dev qtbase5-dev libegl1-mesa-dev libegl-dev libquazip5-dev libpolkit-gobject-1-dev libdbus-1-dev -y
    # Packages for running CoreCtrl
    sudo apt install qml-module-qtquick2 qml-module-qtquick-extras qml-module-qtcharts libbotan-2-19 qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qt-labs-platform -y
    sudo apt clean
    sudo apt autoremove
    vaapiOnFirefox
    #Enabling user-theme Extensions
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
}

enablePlaymouth() {
    # Path to GRUB configuration file
    GRUB_CONFIG_FILE="/etc/default/grub"

    # New line to be inserted
    NEW_GRUB_LINE='GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"'

    # Replace line in GRUB configuration file
    sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|$NEW_GRUB_LINE|" $GRUB_CONFIG_FILE
    sudo update-grub
}
