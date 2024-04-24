#! /usr/bin/env bash

installNvidiaDrivers() {
    print_log "Installing the appropriate GPU drivers..."
    sudo apt install nvidia-driver firmware-misc-nonfree
    sudo nala install nvidia-driver nvidia-opencl-icd libcuda1 libglu1-mesa
    # For h.264 and h.265 export you also need the NVIDIA encode library:
    sudo nala install libnvidia-encode1
    sudo flatpak update
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
    print_log "**⚠️ Installing latest Mesa Vulkan Drivers ⚠️**"
    sudo apt clean
    addMesaSource
    sudo apt update
    sudo apt dist-upgrade -y
    sudo apt install mesa-vulkan-drivers -y
    rollBackSource
}

installSteamAndTools() {
    upgradeSystem
    print_log "\n#################### Installing tools and Steam ####################\n"
    # sudo apt install -y mangohud steam-installer gamescope gamemode mangohud
    # Steam Replaced for Flathub Steam.
    installFlatpak
    flatpak install -y flathub com.valvesoftware.Steam
    installFreedesktopVulkanLayers
    sudo apt clean
}

installBackportUpgrades() {
    sudo apt -t bookworm-backports install linux-image-amd64 linux-headers-amd64 -y
}

installGpuDrivers() {
    if whiptail --title "Installing Latest GPU Drivers" --yesno "Would you like to install the Nvidia GPU drivers on your system? This will entail installing Nvidia-Drivers from the Stable Repository.\
    Please note that this feature is experimental, I do not use or have an Nvidia GPU for test this feature, please notify me if something is wrong." 20 78; then
        print_log "\n###############################################################
##                     Installing Latest GPU Drivers                ##
###############################################################\n"
        # Search for graphics cards in the system using lspci
        gpu_info=$(lspci | grep -i vga)
        # Check GPU manufacturer
        case "$gpu_info" in
        *AMD* | *amd*)
            print_log "**⚠️ An AMD graphics card was detected. Noting to do... ⚠️**"
            ;;
        *NVIDIA* | *nvidia*)
            print_log "**⚠️ A NVIDIA graphics card was detected. ⚠️**"
            installNvidiaDrivers
            ;;
        *Intel* | *intel*)
            print_log "**⚠️ An Intel GPU was detected. Noting to do... ⚠️**"
            ;;
        *)
            print_log "**⚠️ Unknown or no dedicated GPU detected.  Noting to do... ⚠️**"
            ;;
        esac
    fi
}
