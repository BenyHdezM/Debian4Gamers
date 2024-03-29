#! /usr/bin/env bash

installNvidiaDrivers() {
    # Installing the appropriate GPU drivers
    sudo nala install nvidia-driver nvidia-opencl-icd libcuda1 libglu1-mesa
    # For h.264 and h.265 export you also need the NVIDIA encode library:
    sudo nala install libnvidia-encode1
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
    sudo apt clean
    switchToTestingSource
    sudo apt update
    sudo apt install mesa-vulkan-drivers libva-glx2 vainfo -y
    rollBackSource
    cd /tmp
    git clone https://kernel.googlesource.com/pub/scm/linux/kernel/git/firmware/linux-firmware.git
    sudo cp /tmp/linux-firmware/amdgpu/* /lib/firmware/amdgpu 
    sudo update-initramfs -k all -u 
}

installSteamAndTools() {
    upgradeSystem
    print_log "\n#################### Installing firmwares, tools and Steam ####################\n"
    sudo apt install -y mangohud steam-installer gamescope mpv
    # TODO: OBS VKCapture
    sudo apt clean
}

switchToTestingSource() {
    sudo echo -e "\ndeb http://deb.debian.org/debian testing main" | sudo tee -a /etc/apt/sources.list
}

switchToSidSource() {
    sudo echo -e "\ndeb http://deb.debian.org/debian sid main" | sudo tee -a /etc/apt/sources.list
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

installBackportKernel(){
    sudo apt -t stable-backports install linux-image-amd64 -y
    sudo apt -t stable-backports dist-upgrade
}

installGpuDrivers() {
    if whiptail --title "Installing Latest GPU Drivers" --yesno "Would you like to install the latest GPU drivers on your system? This will entail installing MESA from the testing branch or Nvidia-Drivers, depending on your GPU chipset.\
    Please note that this feature is experimental, and while it could potentially enhance performance in many games, particularly those utilizing Ray Tracing, it may not be fully stable. Therefore, I don't recommend it for general use." 20 78; then
        print_log "\n###############################################################
##                     Installing Latest GPU Drivers                ##
###############################################################\n"
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
    fi
    installBackportKernel
}
