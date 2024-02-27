#! /usr/bin/env bash

###############################################################################
#                             Debian4Gamers                                   #
###############################################################################

###############################################################################
#                           DECLARED VARIABLES                                #
###############################################################################
DesktopEnviroment="gnome"

print_log() {
  echo -e "\033[1;33m$1\033[0m"
}

###############################################################################
if [[ -w "/root" ]]; then
  echo "Do not run the script with root"
  exit
  #USER_NAME=$(id -nu 1000)
else
  USER_NAME=$(whoami)
fi
print_log "###############################################################
##                                                           ##
##                Script to Config Debian 12                 ##
##                GNOME for Gaming Experience,               ##
##                by BenyHdez                                ##
##                                                           ##
###############################################################\n"

###############################################################################
#                             Add User to sudoers                             #
###############################################################################
if [[ -e /etc/sudoers.d/$USER_NAME ]]; then
  if whiptail --title "$USER_NAME is already a Sudoers" --yesno "Do you want to remove it from Sudoers?" 8 78; then
    echo -e "Removing $USER_NAME from Sudoers and exit"
    sudo rm /etc/sudoers.d/$USER_NAME
    exit
  fi
else
  print_log "###############################################################
    Hello $USER_NAME, enter the ROOT password 
    to add your user_name:<'$USER_NAME'> to the Sudoers list:                  
###############################################################\n"
  su - root -c 'echo "'${USER_NAME}'  ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/'${USER_NAME}''
fi

print_log "\n###############################################################
    !!Hey $USER_NAME Insert now your USER password         
    ( you are a sudoer now )!!                             
###############################################################\n"
sudo apt update

InstallOptions=$(whiptail --separate-output --title "Check list example" --checklist \
  "Choose user's permissions" 20 78 10 \
  "1" "Install Drivers" ON \
  "2" "Install Extensions" OFF \
  "3" "Install Flatpak and Set Flathub Store" OFF \
  "4" "Install WhiteSur and Gnome Configs" OFF \
  "5" "Install CoreCtrl" OFF \
  "6" "Install LiquidCtl" OFF \
  "7" "Install DisplayLink" OFF 3>&1 1>&2 2>&3)
  

if [ -z "$InstallOptions" ]; then
  echo "No option was selected (user hit Cancel or unselected all options)"
else
  for Option in $InstallOptions; do
    echo $InstallOptions
    case "$Option" in
    "1")
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
      ;;
    "2")
      ###############################################################################
      #                           Installing Extensions                             #
      ###############################################################################

      print_log "\n###############################################################
##          Downloading Gnome Extensions                     ##
###############################################################\n"
      sudo apt install -y lm-sensors gnome-shell-extension-dashtodock gnome-shell-extension-appindicator
      sudo apt clean

      #Install External Extensions
      cd /tmp
      wget -O no-overviewfthx.zip https://extensions.gnome.org/extension-data/no-overviewfthx.v13.shell-extension.zip
      gnome-extensions install --force no-overviewfthx.zip
      rm no-overviewfthx.zip

      print_log "\n###############################################################
##          Installing Gnome Extensions                      ##
###############################################################\n"

      whiptail --title " **⚠️  WARNING ⚠️**  " --msgbox "Important: Please stay alert! Click 'INSTALL' in the next extension popups to proceed with the installation.
Your quick action is needed for a smooth setup. Thank you!" 8 78
      #Installing Extensions
      if whiptail --title "TrayIconsReloaded" --yesno "Do you want to install TrayIconsReloaded extension?" 8 78; then
        cd /tmp
        wget -O trayIconsReloaded.zip https://extensions.gnome.org/extension-data/trayIconsReloadedselfmade.pl.v26.shell-extension.zip
        gnome-extensions install --force trayIconsReloaded.zip
        rm trayIconsReloaded.zip
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "trayIconsReloaded@selfmade.pl"
        gnome-extensions enable trayIconsReloaded@selfmade.pl
        # busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "ubuntu-appindicators@ubuntu.com"
        # gnome-extensions enable ubuntu-appindicators@ubuntu.com
      fi
      if whiptail --title "Dash-To-Dock" --yesno "Do you want to install dash-to-dock extension?" 8 78; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "dash-to-dock@micxgx.gmail.com"
        gnome-extensions enable dash-to-dock@micxgx.gmail.com
      fi
      if whiptail --title "No-Overview" --yesno "Do you want to install ubuntu-appindicators extension?" 8 78; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "no-overview@fthx"
        gnome-extensions enable no-overview@fthx
      fi

      #Enabling user-theme Extensions
      gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
      ;;
    "3")
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
      # sudo flatpak install -y flathub com.spotify.Client
      sudo flatpak install -y flathub com.usebottles.bottles
      sudo flatpak install -y flathub io.github.trigg.discover_overlay
      sudo flatpak install -y flathub com.dec05eba.gpu_screen_recorder
      # sudo flatpak install flathub org.pipewire.Helvum
      ;;
    "4")
      ###############################################################################
      #                   Installing WhiteSur themes                                #
      ###############################################################################
      if whiptail --title "Installing WhiteSur themes" --yesno "Do you want to install WhiteSur?" 8 78; then
        #WhiteSur gtk Installation

        print_log "\n###############################################################
##        Installing WhiteSur gtk,icons,cursors themes       ##
###############################################################\n"
        #Show git branch on Bashrc
        echo PS1="'"'${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\e[91m\]$(__git_ps1)\[\e[00m\]$ '"'" | tee -a ~/.bashrc

        cd /tmp/
        #GTK
        git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
        ./WhiteSur-gtk-theme/install.sh -i debian -l -N glassy
        ./WhiteSur-gtk-theme/tweaks.sh -F
        sudo flatpak override --filesystem=xdg-config/gtk-4.0
        rm ~/.config/gtk-4.0/gtk.css
        ln -s ~/.config/gtk-4.0/gtk-Light.css ~/.config/gtk-4.0/gtk.css
        sudo rm -R WhiteSur-gtk-theme
        #Icons
        git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
        ./WhiteSur-icon-theme/install.sh
        sudo rm -R WhiteSur-icon-theme
        #Cursors
        git clone https://github.com/vinceliuice/WhiteSur-cursors.git
        cd WhiteSur-cursors
        sudo ./install.sh
        cd /tmp/
        sudo sudo rm -R WhiteSur-cursors

        ###############################################################################
        #             Setting up WhiteSur gtk,icons,cursors themes                    #
        ###############################################################################

        print_log "\n###############################################################
##        Setting up WhiteSur gtk,icons,cursors themes       ##
###############################################################\n"

        gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'
        gsettings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors'
        gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Light'
        gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur'
        gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark'

      fi

      #Adding Keybinding for
      ###############################################################################
      #                          Setting up Keybindings                             #
      #                        Terminal and show-desktop                            #
      ###############################################################################
      if whiptail --title "Setting up Keybindings" --yesno "Do you want to setting up my keybindings configuration?" 8 78; then
        print_log "\n###############################################################
##    Setting up Keybindings for Terminal and Show-Desktop   ##
###############################################################\n"
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Terminal"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "$DesktopEnviroment-terminal"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Ctrl><Alt>t"
        gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
      fi

      #Disabling Hot Corner
      if whiptail --title "Disabling Hot Corner" --yesno "Do you wish to disable the Hot Corner?" 8 78; then
        print_log "\n###############################################################
##               Disabling Gnome-Shell Hot Corner            ##
###############################################################\n"
        gsettings set org.gnome.desktop.interface enable-hot-corners false
      fi

      #GRUB FALLOUT THEME
      if whiptail --title "GRUB FALLOUT THEME" --yesno "Are you interested in installing the GRUB theme 'shvchk/grub-theme' from GitHub?" 8 78; then
        print_log "\n###############################################################
##            Setting up fallout-grub-theme English          ##
###############################################################\n"
        wget -O- https://github.com/shvchk/fallout-grub-theme/raw/master/install.sh | bash
      fi

      ###############################################################################
      #                         Setting up xfce4-terminal                           #
      ###############################################################################
      if whiptail --title "xfce4-terminal" --yesno "Are you interested in installing the xfce4-terminal? This will replace the Default Terminal" 8 78; then
        print_log "\n###############################################################
##                  Setting up xfce4-terminal                ##
###############################################################\n"
        sudo apt install xfce4-terminal -y
        sudo apt clean
        DesktopEnviroment="xfce4"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "$DesktopEnviroment-terminal"
        sudo apt purge gnome-terminal gnome-console -y
        if [[ -e ~/.config/xfce4/terminal/terminalrc ]]; then
          wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/terminalrc -O ~/.config/xfce4/terminal/terminalrc
        else
          mkdir -p ~/.config/xfce4/terminal/
          wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/terminalrc -O ~/.config/xfce4/terminal/terminalrc
        fi
      fi
      ;;
    "5")
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
      ;;
    "6")
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
      ;;
    "7")
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
      ;;
    *)
      echo "Unsupported item $Options!" >&2
      exit 1
      ;;
    esac
  done
fi

###############################################################################
#                                 REBOOT                                      #
###############################################################################
sudo apt autoremove -y
if whiptail --title "Installation Complete" --yesno "To apply changes, please reboot your system Would you like to reboot now?" 8 78; then
  sudo reboot
else
  echo -e "\nEnsure to reboot your system soon to apply the changes"
fi

#TODO: Add AMD Firmware:
# https://askubuntu.com/questions/1124253/missing-firmware-for-amdgpu

#TODO: Disable Gnome-Clasic-Xorg

#TODO: Edit splash for Grub

#TODO: NVIDIA Support
# Installing the appropriate GPU drivers
# sudo apt-get install nvidia-driver nvidia-opencl-icd libcuda1 libglu1-mesa
# For h.264 and h.265 export you also need the NVIDIA encode library:
# sudo apt-get install libnvidia-encode1

#TODO: SET AMDGPU-PRO
# wget https://repo.radeon.com/amdgpu-install/23.40.1/ubuntu/jammy/amdgpu-install_6.0.60001-1_all.deb -O amdgpu-install.deb
# sudo apt install ./amdgpu-install.deb -y
# amdgpu-install --opencl=rocr -y
# rm amdgpu-install.deb
# sudo apt clean

#TOD0: Davinci_Resolve for Debian
# wget https://swr.cloud.blackmagicdesign.com/DaVinciResolve/v18.6.4/DaVinci_Resolve_18.6.4_Linux.zip?verify=1706867615-BJMMD0Y7fn%2F1TNfWvyHkxQY%2BsTx6m0q7g%2BBcsnumqNw%3D
# sudo apt install fakeroot xorriso

#PROTONVPN
#wget -O protonvpn.deb https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-2_all.deb
#sudo apt install ./protonvpn.deb
#sudo apt-get update
#sudo apt-get install proton-vpn-gnome-desktop

#TODO FOR LAPTOPS:
#Install auto-cpufreq
#install fingerprint
