#! /usr/bin/env bash

enablelFullAmdGpuControl() {
    gpu_info=$(lspci | grep -i vga)
    # Check GPU manufacturer
    if [[ "$gpu_info" == *AMD* || "$gpu_info" == *amd* ]]; then
        print_log "**⚠️ Enable Full AMD GPU controls - Grub Update⚠️**"

        # Path to GRUB configuration file
        GRUB_CONFIG_FILE="/etc/default/grub"

        # New line to be inserted
        NEW_GRUB_LINE='GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.ppfeaturemask=0xffffffff"'

        # Replace line in GRUB configuration file
        sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|$NEW_GRUB_LINE|" $GRUB_CONFIG_FILE
        sudo update-grub

        print_log "**⚠️ GRUB configuration updated successfully. ⚠️**"
    fi
}

installCoreCtrl() {
    ###############################################################################
    #                         Compile and Install CoreCtrl                        #
    ###############################################################################
    if whiptail --title "CoreCtrl" --yesno "Are you insterested on Compile and Install CoreCtrl?" 8 78; then
        print_log "\n###############################################################
##               Compile and Install CoreCtrl                ##
###############################################################\n"

        whiptail --title " **⚠️  WARNING ⚠️**  " --msgbox "Please don't touch anything until the process is completed, compile process will use all your CPU." 8 78
        # Download and build
        cd
        git clone https://gitlab.com/corectrl/corectrl.git
        cd corectrl
        git checkout 1.3-stable
        mkdir build
        cd build
        cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
        # Get the number of processors and subtract two
        num_processors=$(grep -c ^processor /proc/cpuinfo)
        num_jobs=$((num_processors - 2))
        make -j$num_jobs #Run make with the set number of jobs
        sudo make install
        enablelFullAmdGpuControl
    fi
}

installLiquidCtl() {
    ###############################################################################
    #                              Install LiquidCtl                              #
    ###############################################################################
    if whiptail --title "LiquidCtl" --yesno "Do you want to Install LiquidCtl?" 8 78; then
        print_log "\n###############################################################
##                     Installing LiquidCtl                  ##
###############################################################\n"
        sudo apt install liquidctl -y
        sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/liquidcfg.service -O /etc/systemd/system/liquidcfg.service
        sudo systemctl daemon-reload
        sudo systemctl start liquidcfg
        sudo systemctl enable liquidcfg
    fi
}

installAutoCpuFreq() {
    ###############################################################################
    #                            Install Auto-CpuFreq                             #
    ###############################################################################
    if whiptail --title "Auto-CpuFreq" --yesno "Do you want to Install Auto-CpuFreq?" 8 78; then
        print_log "\n###############################################################
##                     Installing Auto-CpuFreq                  ##
###############################################################\n"
        cd /tmp
        git clone https://github.com/AdnanHodzic/auto-cpufreq.git
        cd auto-cpufreq && sudo ./auto-cpufreq-installer --install
        sudo auto-cpufreq --install
    fi
}

installDisplayLink() {
    ###############################################################################
    #                             Install DisplayLink                             #
    ###############################################################################
    print_log "\n###############################################################
##                     Installing DisplayLink                ##
###############################################################\n"
    cd /tmp
    wget -O synaptics.deb https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb
    sudo apt install /tmp/synaptics.deb
    sudo apt update
    sudo apt install displaylink-driver -y
}

installVSCode() {
    print_log "\n###############################################################
##                  Installing Visual Studio Code            ##
###############################################################\n"
    sudo apt-get install wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    # Then update the package cache and install the package using:
    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code # or code-insiders
}
