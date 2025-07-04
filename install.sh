#! /usr/bin/env bash

###############################################################################
#                             Debian4Gamers                                   #
###############################################################################

importSource() {
  archivo="$1"
  if [ -f "$archivo" ]; then
    source "$archivo"
  else
    wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/$archivo -O /tmp/$archivo
    source /tmp/$archivo
  fi
}

print_log() {
  echo -e "\033[1;33m$1\033[0m"
}

importSource "utils.sh"
importSource "install_drivers.sh"
importSource "install_extensions.sh"
importSource "install_flatpak.sh"
importSource "install_gnome_theme.sh"
importSource "install_extras.sh"
importSource "install_drivers.sh"

if [[ -w "/root" ]]; then
  print_log "Do not run the script with root"
  exit
else
  USER_NAME=$(whoami)
fi

###############################################################################

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
  print_log "**⚠️ $USER_NAME is already a Sudoers ⚠️**"
else
  print_log "###############################################################
    Hello $USER_NAME, enter the ROOT password 
    to add your user_name:<'$USER_NAME'> to the Sudoers list:                  
###############################################################\n"
  su - root -c 'echo "'${USER_NAME}'  ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/'${USER_NAME}''
  su - root -c 'echo | sudo usermod -aG sudo '${USER_NAME}''
fi

print_log "\n###############################################################
    !!Hey $USER_NAME Insert now your USER password         
    ( you are a sudoer now )!!                             
###############################################################\n"

sudo rm -rf /tmp/*
upgradeSystem
installDependencies
installFlatpak
defaultGrubEnhanced

InstallOptions=$(whiptail --separate-output --title "Installation Options" --checklist \
  "Choose Installation Options" 20 75 12 \
  "1" "Install Steam, Flatpak and Tools ( Highly Recommended )" ON \
  "2" "Install Extensions ( Recommended ) " ON \
  "3" "Install Recomended Apps ( Recommended ) " ON \
  "4" "Install WhiteSur Theme and Configs ( Recommended )" ON \
  "5" "Install CoreCtrl ( AMD GPUs Controls ) " OFF \
  "6" "Install LiquidCtl ( Liquid Cooling Control ) " OFF \
  "7" "Install Auto-CpuFreq ( Battery Performance )" OFF \
  "8" "Install DisplayLink Driver ( Extra ) " OFF \
  "9" "Install Visual Studio Code ( Extra ) " OFF \
  "10" "Install GPU Drivers ( Nvidia Privative Drivers ) " OFF \
  "11" "Disable Wayland ( Default Xorg for Legacy support ) " OFF 3>&1 1>&2 2>&3)

if [ -z "$InstallOptions" ]; then
  echo "No option was selected (user hit Cancel or unselected all options)"
else
  for Option in $InstallOptions; do
    echo $InstallOptions
    case "$Option" in
    "1")

      installSteamAndTools
      ;;
    "2")
      installExtensions
      ;;
    "3")
      installFlatpakApps
      ;;
    "4")
      installGnomeTheme
      ;;
    "5")
      installCoreCtrl
      ;;
    "6")
      installLiquidCtl
      ;;
    "7")
      installAutoCpuFreq
      ;;
    "8")
      installDisplayLink
      ;;
    "9")
      installVSCode
      ;;
    "10")
      installPrivativeGpuDrivers
      ;;
    "11")
      disableWayland
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
  print_log "\nEnsure to reboot your system soon to apply the changes"
fi
