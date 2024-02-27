#! /usr/bin/env bash

installDrivers() {
    ###############################################################################
    #                   Updating all the system                                   #
    ###############################################################################

    sudo dpkg --add-architecture i386 #Add x86 Architecture (Needed for Steam-Installer)
    sudo rm /etc/apt/sources.list
    sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/stable_sources.list -O /etc/apt/sources.list

    print_log "\n###############################################################
##    Upgrading the entire system preparation...             ##
###############################################################\n"
    sudo apt update
    sudo apt dist-upgrade -y

    ###############################################################################
    #               Upgrading MESA VULKAN DRIVERS from Testing branch             #
    ###############################################################################
    print_log "\n###############################################################
##                 Installing MESA VULKAN DRIVERS            ##
###############################################################\n"
    echo "deb http://deb.debian.org/debian testing main" | sudo tee -a /etc/apt/sources.list
    sudo apt update
    sudo apt install -y mesa-vulkan-drivers

    echo -e "\n#################### Installing firmwares, tools and Steam ####################\n"
    sudo apt install -y neofetch mangohud git mesa-opencl-icd steam-installer bash-completion vulkan-tools firmware-linux firmware-linux-free firmware-linux-nonfree firmware-amd-graphics
    sudo apt clean

    ###############################################################################
    #                   Rollback - remove Testing branch                          #
    ###############################################################################
    print_log "#################### Rollingback -> removing Testing branch ####################\n"
    sudo rm /etc/apt/sources.list
    sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/stable_sources.list -O /etc/apt/sources.list
    sudo apt update
}
