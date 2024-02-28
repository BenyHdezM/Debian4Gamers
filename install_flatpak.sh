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
        "6" "Install Helvum" OFF \
        "7" "Install Heroic Launcher" OFF \
        "8" "Install Telegram" OFF 3>&1 1>&2 2>&3)

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
                sudo flatpak install -y flathub org.pipewire.Helvum
                ;;
            "7")
                sudo flatpak install -y flathub com.heroicgameslauncher.hgl
                ;;
            "8")
                sudo flatpak install -y flathub org.telegram.desktop
                ;;
            *)
                echo "Unsupported item $Options!" >&2
                exit 1
                ;;
            esac
        done
    fi
}
