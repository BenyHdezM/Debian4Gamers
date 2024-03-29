#! /usr/bin/env bash

###############################################################################
#                             Debian4Gamers                                   #
###############################################################################

###############################################################################
#                           DECLARED VARIABLES                                #
###############################################################################

importSource() {
  archivo="$1"
  if [ -f "$archivo" ]; then
    source "$archivo"
  else
    sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/$archivo -O /tmp/$archivo
    source /tmp/$archivo
  fi
}

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
sudo rm -rf /tmp/*
importSource "utils.sh"
upgradeSystem
installDependencies
enablePlaymouth

InstallOptions=$(whiptail --separate-output --title "Installation Options" --checklist \
  "Choose Installation Options" 15 70 10 \
  "1" "Install Steam, MangoHud and Tools ( Highly Recommended )" ON \
  "2" "Install Extensions ( Recommended ) " ON \
  "3" "Install Flatpak and Set Flathub Store ( Recommended ) " ON \
  "4" "Install WhiteSur and Gnome Configs ( Recommended )" ON \
  "5" "Install CoreCtrl ( OC ) " OFF \
  "6" "Install LiquidCtl ( Liquid Cooling Control ) " OFF \
  "7" "Install Auto-CpuFreq ( Battery Performance )" OFF \
  "8" "Install DisplayLink Driver ( Extra ) " OFF \
  "9" "Install Visual Studio Code ( Extra ) " OFF \
  "10" "Install GPU Latest Drivers ( EXperimental ) " OFF 3>&1 1>&2 2>&3)

if [ -z "$InstallOptions" ]; then
  echo "No option was selected (user hit Cancel or unselected all options)"
else
  for Option in $InstallOptions; do
    echo $InstallOptions
    case "$Option" in
    "1")
      importSource "install_drivers.sh"
      installSteamAndTools
      ;;
    "2")
      importSource "install_extensions.sh"
      installExtensions
      ;;
    "3")
      importSource "install_flatpak.sh"
      installFlatpak
      ;;
    "4")
      importSource "install_gnome_theme.sh"
      installGnomeTheme
      ;;
    "5")
      importSource "install_extras.sh"
      installCoreCtrl
      ;;
    "6")
      importSource "install_extras.sh"
      installLiquidCtl
      ;;
    "7")
      importSource "install_extras.sh"
      installAutoCpuFreq
      ;;
    "8")
      importSource "install_extras.sh"
      installDisplayLink
      ;;
    "9")
      importSource "install_extras.sh"
      installVSCode
      ;;
    "10")
      importSource "install_drivers.sh"
      installGpuDrivers
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

###### TODO IDEAS #######: 

# Set Gnome shell X11 as Default
# Edit splash for Grub

# Davinci_Resolve for Debian
# wget https://swr.cloud.blackmagicdesign.com/DaVinciResolve/v18.6.4/DaVinci_Resolve_18.6.4_Linux.zip?verify=1706867615-BJMMD0Y7fn%2F1TNfWvyHkxQY%2BsTx6m0q7g%2BBcsnumqNw%3D
# sudo apt install fakeroot xorriso

#FOR LAPTOPS:
#install fingerprint
