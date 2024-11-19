#! /usr/bin/env bash

upgradeSystem() {
    ###############################################################################
    #                   Updating all the system                                   #
    ###############################################################################
    echo "vm.max_map_count=1048576" | sudo tee -a /etc/sysctl.conf
    sudo rm /etc/apt/sources.list

    if [ -f "stable_sources.list" ]; then
        sudo cp stable_sources.list /etc/apt/sources.list
    else
        sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/stable_sources.list -O /etc/apt/sources.list
    fi

    print_log "\n###############################################################
##    Upgrading the entire system preparation...             ##
###############################################################\n"
    sudo apt update
    # sudo dpkg --add-architecture i386 #Add x86 Architecture (Needed for Steam-Installer)
    sudo apt dist-upgrade -y
    sudo apt autoremove -y
    sudo apt install linux-image-amd64 -t stable-backports
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
    sudo apt install -y libavcodec-extra bpytop neofetch git mpv mesa-opencl-icd bash-completion vulkan-tools vainfo firmware-linux firmware-linux-free firmware-linux-nonfree firmware-amd-graphics
    sudo apt install -y lm-sensors gnome-shell-extension-dashtodock gnome-shell-extension-appindicator
    sudo apt clean
    sudo apt autoremove
    vaapiOnFirefox
    #Enabling user-theme Extensions
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
    gsettings set org.gnome.mutter check-alive-timeout 10000
    gnome-extensions enable ubuntu-appindicators@ubuntu.com
}

defaultGrubEnhanced() {
    gpu_info=$(lspci | grep -i vga)
    # Check GPU manufacturer
    # Path to GRUB configuration file

    GRUB_CONFIG_FILE="/etc/default/grub"
    if [[ "$gpu_info" == *AMD* || "$gpu_info" == *amd* ]]; then
        print_log "**⚠️ Enable Full AMD GPU controls - Grub Update⚠️**"

        # New line to be inserted
        NEW_GRUB_LINE='GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.ppfeaturemask=0xffffffff"'

        # Replace line in GRUB configuration file
        sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|$NEW_GRUB_LINE|" $GRUB_CONFIG_FILE
        sudo update-grub

    else
        # New line to be inserted
        NEW_GRUB_LINE='GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"'
    fi

    # Replace line in GRUB configuration file
    sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|$NEW_GRUB_LINE|" $GRUB_CONFIG_FILE
    sudo update-grub
    print_log "**⚠️ GRUB configuration updated successfully. ⚠️**"
}

installFlatpak() {
    ###############################################################################
    #                   Installing Flatpak and Flathub Store                      #
    ###############################################################################
    print_log "\n###############################################################
##           Installing Flatpak and Flathub Store            ##
###############################################################\n"

    #TODO: whiptail Selector for all flatpaks
    sudo apt install -y flatpak gnome-software-plugin-flatpak
    sudo apt clean
    ## sudo apt install plasma-discover-backend-flatpak  ## TODO: Identify if plasma-discover is installed
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

disableWayland() {
    sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/daemon.conf
}
