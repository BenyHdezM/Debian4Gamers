#! /usr/bin/env bash

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

    #Install Discord, Spotify and ProtonUp-Qt
    print_log "\n###############################################################
##         Installing Discord, Spotify and ProtonUp-Qt       ##
###############################################################\n"

    InstallOptions=$(whiptail --separate-output --title "Flatpak Apps Options" --checklist \
        "Choose Flatpak Apps to Install" 20 78 10 \
        "1" "Install Discord" ON \
        "2" "Install ProtonUp-Qt" OFF \
        "3" "Install Spotify" OFF \
        "4" "Install Bottles" OFF \
        "5" "Install GPU Screen Recorder" OFF \
        "6" "Install OBS-Studio" OFF \
        "7" "Install Helvum" OFF \
        "8" "Install Heroic Launcher" OFF \
        "9" "Install Telegram" OFF \
        "10" "Install Proton VPN" OFF 3>&1 1>&2 2>&3)

    if [ -z "$InstallOptions" ]; then
        echo "No option was selected (user hit Cancel or unselected all options)"
    else
        for Option in $InstallOptions; do
            echo $InstallOptions
            case "$Option" in
            "1")
                sudo flatpak install -y flathub com.discordapp.Discord
                sudo flatpak install -y flathub io.github.trigg.discover_overlay
                ;;
            "2")
                sudo flatpak install -y flathub net.davidotek.pupgui2
                ;;
            "3")
                sudo flatpak install -y flathub com.spotify.Client
                ;;
            "4")
                sudo flatpak install -y flathub com.usebottles.bottles
                ;;
            "5")
                sudo flatpak install -y flathub com.dec05eba.gpu_screen_recorder
                ;;
            "6")
                installVKCapture
                sudo flatpak install -y com.obsproject.Studio
                sudo flatpak install -y org.freedesktop.Platform.GStreamer.gstreamer-vaapi/x86_64/23.08
                sudo flatpak install -y com.obsproject.Studio.Plugin.Gstreamer/x86_64/stable
                sudo flatpak install -y com.obsproject.Studio.Plugin.BackgroundRemoval
                sudo flatpak install -y org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08
                sudo flatpak install -y com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable
                ;;
            "7")
                sudo flatpak install -y flathub org.pipewire.Helvum
                ;;
            "8")
                sudo flatpak install -y flathub com.heroicgameslauncher.hgl
                ;;
            "9")
                sudo flatpak install -y flathub org.telegram.desktop
                ;;
            "10")
                cd /tmp
                wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-2_all.deb
                sudo dpkg -i ./protonvpn-stable-release_1.0.3-2_all.deb && sudo apt update
                sudo apt update && sudo apt upgrade
                sudo apt install proton-vpn-gnome-desktop
                sudo apt install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1
                ;;
            *)
                echo "Unsupported item $Options!" >&2
                exit 1
                ;;
            esac
        done
    fi
}

installVKCapture() {
    sudo apt install -y cmake libobs-dev libvulkan-dev libgl-dev libegl-dev libx11-dev libxcb1-dev libwayland-client0 wayland-scanner++
    cd /tmp
    git clone https://github.com/nowrep/obs-vkcapture.git
    cd /tmp/obs-vkcapture
    mkdir build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
    make && sudo make install
    print_log "1. Add Game Capture to your OBS scene."
    print_log "2. Start the game with capture enabled obs-gamecapture %command%."
    print_log "3. (Recommended) Start the game with only Vulkan capture enabled env OBS_VKCAPTURE=1 %command%."
}
