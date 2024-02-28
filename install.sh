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
  print_log "Do not run the script with root"
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
  # if whiptail --title "$USER_NAME is already a Sudoers" --yesno "Do you want to remove it from Sudoers?" 8 78; then
  #   echo -e "Removing $USER_NAME from Sudoers and exit"
  #   sudo rm /etc/sudoers.d/$USER_NAME
  #   exit
  # fi
  print_log "**⚠️ $USER_NAME is already a Sudoers ⚠️**"
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
sudo echo #Get password

InstallOptions=$(whiptail --separate-output --title "Installation Options" --checklist \
  "Choose Installation Options" 20 78 10 \
  "1" "Install Drivers" ON \
  "2" "Install Extensions" OFF \
  "3" "Install Flatpak and Set Flathub Store" OFF \
  "4" "Install WhiteSur and Gnome Configs" OFF \
  "5" "Install CoreCtrl" OFF \
  "6" "Install LiquidCtl" OFF \
  "7" "Install DisplayLink" OFF \
  "8" "Install Visual Studio Code" OFF 3>&1 1>&2 2>&3)

if [ -z "$InstallOptions" ]; then
  echo "No option was selected (user hit Cancel or unselected all options)"
else
  for Option in $InstallOptions; do
    echo $InstallOptions
    case "$Option" in
    "1")
      sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/install_drivers.sh -O /tmp/install_drivers.sh
      source /tmp/install_drivers.sh
      installDrivers
      ;;
    "2")
      sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/install_extensions.sh -O /tmp/install_extensions.sh
      source /tmp/install_extensions.sh
      installExtensions
      ;;
    "3")
      sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/install_flatpak.sh -O /tmp/install_flatpak.sh
      source /tmp/install_flatpak.sh
      installFlatpak
      ;;
    "4")
      sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/install_gnome_theme.sh -O /tmp/install_gnome_theme.sh
      source /tmp/install_gnome_theme.sh
      installGnomeTheme
      ;;
    "5")
      sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/install_extras.sh -O /tmp/install_extras.sh
      source /tmp/install_extras.sh
      installCoreCtrl
      ;;
    "6")
      sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/install_extras.sh -O /tmp/install_extras.sh
      source /tmp/install_extras.sh
      installLiquidCtl
      ;;
    "7")
      sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/install_extras.sh -O /tmp/install_extras.sh
      source /tmp/install_extras.sh
      installDisplayLink
      ;;
    "8")
      sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/install_extras.sh -O /tmp/install_extras.sh
      source /tmp/install_extras.sh
      installVSCode
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
