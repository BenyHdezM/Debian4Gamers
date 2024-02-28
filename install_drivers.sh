#! /usr/bin/env bash

upgradeSystem(){
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

installNvidiaDrivers() {
    # Installing the appropriate GPU drivers
    sudo apt-get install nvidia-driver nvidia-opencl-icd libcuda1 libglu1-mesa
    # For h.264 and h.265 export you also need the NVIDIA encode library:
    sudo apt-get install libnvidia-encode1
}

installAMDPRO() {
    wget https://repo.radeon.com/amdgpu-install/23.40.1/ubuntu/jammy/amdgpu-install_6.0.60001-1_all.deb -O amdgpu-install.deb
    sudo apt install ./amdgpu-install.deb -y
    amdgpu-install --opencl=rocr -y
    rm amdgpu-install.deb
    sudo apt clean
}

installMesaDrivers() {
    ###############################################################################
    #               Upgrading MESA VULKAN DRIVERS from Testing branch             #
    ###############################################################################
    print_log "\n###############################################################
##                 Installing MESA VULKAN DRIVERS            ##
###############################################################\n"
    switchToTestingSource
    sudo apt update
    sudo apt install -y mesa-vulkan-drivers
    rollBackSource
}

installSteamAndTools() {
    upgradeSystem
    print_log "\n#################### Installing firmwares, tools and Steam ####################\n"
    sudo apt install -y neofetch mangohud git mesa-opencl-icd steam-installer bash-completion vulkan-tools firmware-linux firmware-linux-free firmware-linux-nonfree firmware-amd-graphics
    sudo apt clean
}

switchToTestingSource() {
    echo "deb http://deb.debian.org/debian testing main" | sudo tee -a /etc/apt/sources.list
}

switchToSidSource() {
    echo "deb http://deb.debian.org/debian sid main" | sudo tee -a /etc/apt/sources.list
}

rollBackSource() {
    ###############################################################################
    #                   Rollback - remove Testing branch                          #
    ###############################################################################
    print_log "\n###############################################################
##         Rollingback -> removing Testing branch            ##
###############################################################\n"
    sudo rm /etc/apt/sources.list
    sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/stable_sources.list -O /etc/apt/sources.list
    sudo apt update
    sudo apt autoremove -y
}

installGpuDrivers() {
    # Search for graphics cards in the system using lspci
    gpu_info=$(lspci | grep -i vga)
    # Check GPU manufacturer
    case "$gpu_info" in
    *AMD* | *amd*)
        print_log "**⚠️ An AMD graphics card was detected. ⚠️**"
        installMesaDrivers
        ;;
    *NVIDIA* | *nvidia*)
        print_log "**⚠️ A NVIDIA graphics card was detected. ⚠️**"
        installNvidiaDrivers
        ;;
    *Intel* | *intel*)
        print_log "**⚠️ An Intel GPU was detected. ⚠️**"
        installMesaDrivers
        ;;
    *)
        print_log "**⚠️ Unknown or no dedicated GPU detected. Installing Mesa drivers. ⚠️**"
        installMesaDrivers
        ;;
    esac

}
