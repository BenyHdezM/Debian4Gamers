#! /usr/bin/env bash

installCoreCtrl() {
    ###############################################################################
    #              Adding CoreCtrl source and Install CoreCtrl                    #
    ###############################################################################
    gpu_info=$(lspci | grep -i vga)
    # Check GPU manufacturer
    # Path to GRUB configuration file

    GRUB_CONFIG_FILE="/etc/default/grub"
    if [[ "$gpu_info" == *AMD* || "$gpu_info" == *amd* ]]; then
        sudo apt-get update
        sudo apt install corectrl -y
    else
        print_log "**⚠️ Not AMD GPU detected... ignoring step ⚠️**"
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
    sudo extrepo enable vscode
    sudo extrepo update vscode
    sudo apt update
    sudo apt install code -y
}

installFirefoxLatest(){
    sudo extrepo enable mozilla
    sudo extrepo update mozilla
    sudo apt update
    sudo apt remove firefox-esr -y
    sudo apt install firefox -y
}