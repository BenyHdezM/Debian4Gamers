#! /usr/bin/env bash
echo -e "##########################################
##                                      ##
##      Script to Config Debian 12      ##
##      For Gaming Experience,          ##
##      by BenyHdez                     ##
##                                      ##
##########################################\n"

#Get Main User Name
if [[ -w "/root" ]]; then
  echo "Do not run the script with root"
  exit
  #USER_NAME=$(id -nu 1000)
else
  USER_NAME=$(whoami)
fi


if [[ -e /etc/sudoers.d/$USER_NAME ]]; then
echo -e "Hello $USER_NAME your User is already a Sudoers:\n"
sudo rm /etc/sudoers.d/$USER_NAME
#su - root -c 'rm /etc/sudoers.d/'${USER_NAME}'' #This is for clean the sudoer file
else
#Add User to sudoers
echo -e "Hello $USER_NAME Please insert the ROOT password to add your User to Sudoers:\n" 
su - root -c 'echo "'${USER_NAME}'  ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/'${USER_NAME}''
echo -e "Adding $USER_NAME to Sudoers....\nThe User: $USER_NAME have now access to sudo\n"
fi

exit
#Install all dependencies for Gaming
echo -e "$USER_NAME Insert now your USER password (not the root one, now you are a sudoer)\n" 
sudo dpkg --add-architecture i386
sudo cp bookworm_sources.list /etc/apt/sources.list
sudo apt update
sudo apt dist-upgrade
sudo apt install firmware-amd-graphics nala git mesa-opencl-icd steam-installer


sudo apt update
sudo apt install mesa-vulkan-drivers

#Install Extensios
sudo apt install lm-sensors gnome-shell-extension-dashtodock gnome-shell-extension-appindicator

# #Enable Extensions
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable ubuntu-appindicators@ubuntu.com
gnome-extensions enable dash-to-dock@micxgx.gmail.com

#FLATPAK + FLATHUB
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
## sudo apt install plasma-discover-backend-flatpak  ## TODO: Identify if plasma-discover is installed
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

#WhiteSur gtk Installation
if [[ -w "/root" ]]; then
  echo "Not install themes with root"
else
mkdir /tmp/whitesur
cd /tmp/whitesur
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
git clone https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-gtk-theme
./install.sh -i debian
./tweaks.sh -F
cd ../WhiteSur-icon-theme
./install.sh
cd ../WhiteSur-cursors
sudo ./install.sh

sudo rm -R /tmp/whitesur 
fi


sudo reboot





#echo "$USER_NAME"
