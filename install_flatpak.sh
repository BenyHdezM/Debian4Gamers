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
    sudo flatpak install -y flathub com.discordapp.Discord
    sudo flatpak install -y flathub net.davidotek.pupgui2
    sudo flatpak install -y flathub com.spotify.Client
    sudo flatpak install -y flathub com.usebottles.bottles
    sudo flatpak install -y flathub io.github.trigg.discover_overlay
    sudo flatpak install -y flathub com.dec05eba.gpu_screen_recorder
    sudo flatpak install -y flathub org.pipewire.Helvum
}
