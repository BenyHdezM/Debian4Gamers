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
    selectKernel
}

selectKernel(){
    PACKAGE="linux-image-amd64"

    # Obtener versiones exactas desde madison
    experimental_version=$(apt-cache madison $PACKAGE | grep experimental | head -n1 | awk '{print $3}')
    backports_version=$(apt-cache madison $PACKAGE | grep backports | head -n1 | awk '{print $3}')
    stable_version=$(apt-cache madison $PACKAGE | grep stable/main | head -n1 | awk '{print $3}')

    InstallOptions=$(whiptail --separate-output --title "Select Kernel" --radiolist \
"⚠️  Using a newer kernel can offer benefits in some cases, but it's important to remember that Debian’s focus is on stability. Newer kernels should generally be used only when required for specific hardware or use cases.
⚠️   The Experimental kernel may deliver the best performance, especially for gaming, but it comes with the trade-off of manual updates and potential instability..
✅   Stable Backports auto-update by default, offering a safer and more reliable option for most users, especially if your hardware is not too old." 14 115 3 \
        "1" "Experimental     - versión: ${experimental_version} | For cutting-edge hardware " OFF \
        "2" "Stable Backports - versión: ${backports_version} | For hardware that's not too new, but not too old " OFF \
        "3" "Stable - versión: ${stable_version} | Recommended for supported and stable hardware " ON 3>&1 1>&2 2>&3)

    if [ -z "$InstallOptions" ]; then
        echo "No option was selected (user hit Cancel or unselected all options)"
    else
        for Option in $InstallOptions; do
            echo $InstallOptions
            case "$Option" in
            "1")
                sudo apt install linux-base firmware-linux -t stable-backports
                sudo apt install linux-image-amd64 -t experimental
                ;;
            "2")
                sudo apt install linux-image-amd64 firmware-linux -t stable-backports
                ;;
            "3")
                sudo apt install linux-image-amd64
                ;;
            *)
                echo "Unsupported item $Options!" >&2
                exit 1
                ;;
            esac
        done
    fi
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
    sudo apt install -y lm-sensors gnome-shell-extension-dashtodock gnome-shell-extension-appindicator preload extrepo rar unrar zip unzip 7zip

    sudo apt clean
    sudo apt autoremove
    vaapiOnFirefox
    #Enabling user-theme Extensions
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
    #This make Gnome give more time to Steam to react
    gsettings set org.gnome.mutter check-alive-timeout 10000
    #This fix the Gnome-Calculator Crashes.
    gsettings set org.gnome.calculator refresh-interval 0
    sudo systemctl enable preload
    sudo systemctl start preload
    #Enable Extrepo non-free
    sudo cp /etc/extrepo/config.yaml /etc/extrepo/config.yaml.bak

    #Uncomment Lines
    sudo sed -i 's/^# -\s*\(main\|contrib\|non-free\)/- \1/' /etc/extrepo/config.yaml
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
    #sudo flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
}

disableWayland() {
    sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/daemon.conf
}
