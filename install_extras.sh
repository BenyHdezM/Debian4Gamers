#! /usr/bin/env bash

installCoreCtrl() {
    ###############################################################################
    #                         Compile and Install CoreCtrl                        #
    ###############################################################################
    if whiptail --title "CoreCtrl" --yesno "Are you insterested on Compile and Install CoreCtrl?" 8 78; then
        print_log "\n###############################################################
##               Compile and Install CoreCtrl                ##
###############################################################\n"
        whiptail --title " **⚠️  WARNING ⚠️**  " --msgbox "Please don't touch anything until the process is completed, compile process will use all your CPU." 8 78
        # Packages for compiling
        sudo apt install cmake extra-cmake-modules libquazip1-qt5-dev libspdlog-dev qttools5-dev qtdeclarative5-dev libqt5charts5-dev libqt5svg5-dev libbotan-2-dev libqca-qt5-2-dev libdrm-dev qtbase5-dev libegl1-mesa-dev libegl-dev libquazip5-dev libpolkit-gobject-1-dev libdbus-1-dev -y
        # Packages for running the application
        sudo apt install qml-module-qtquick2 qml-module-qtquick-extras qml-module-qtcharts libbotan-2-19 qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qt-labs-platform -y
        # Download and build
        sudo apt clean
        cd ~/
        git clone https://gitlab.com/corectrl/corectrl.git
        git checkout 1.3-stable
        cd corectrl
        mkdir build
        cd build
        cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
        # Get the number of processors and subtract two
        num_processors=$(grep -c ^processor /proc/cpuinfo)
        num_jobs=$((num_processors - 2))
        make -j$num_jobs #Run make with the set number of jobs

        sudo make install
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
        sudo apt install liquidctl
        sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/liquidcfg.service -O /etc/systemd/system/liquidcfg.service
        sudo systemctl daemon-reload
        sudo systemctl start liquidcfg
        sudo systemctl enable liquidcfg
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
