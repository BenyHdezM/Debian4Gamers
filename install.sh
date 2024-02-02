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
  echo -e "Removing $USER_NAME from Sudoers and exit"
  sudo rm /etc/sudoers.d/$USER_NAME
  exit
else
  #Add User to sudoers
  echo -e "Hello $USER_NAME Please insert the ROOT password to add your User to Sudoers:\n" 
  su - root -c 'echo "'${USER_NAME}'  ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/'${USER_NAME}''
  echo -e "Adding $USER_NAME to Sudoers....\nThe User: $USER_NAME have now access to sudo\n"
fi

#Install all dependencies for Gaming
echo -e "$USER_NAME Insert now your USER password (not the root one, now you are a sudoer)\n" 
sudo dpkg --add-architecture i386
sudo cp bookworm_sources.list /etc/apt/sources.list
sudo apt update
sudo apt dist-upgrade
sudo apt install -y firmware-amd-graphics nala mangohud git mesa-opencl-icd steam-installer

sudo apt update
sudo apt install -y mesa-vulkan-drivers

#Install Extensios
sudo apt install -y lm-sensors gnome-shell-extension-dashtodock gnome-shell-extension-appindicator

# #Enable Extensions
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable ubuntu-appindicators@ubuntu.com
gnome-extensions enable dash-to-dock@micxgx.gmail.com

#FLATPAK + FLATHUB
sudo apt install -y flatpak
sudo apt install -y gnome-software-plugin-flatpak
## sudo apt install plasma-discover-backend-flatpak  ## TODO: Identify if plasma-discover is installed
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

#Install Discord, Spotify and ProtonUp-Qt
sudo flatpak install -y flathub com.discordapp.Discord
sudo flatpak install -y flathub net.davidotek.pupgui2
sudo flatpak install -y flathub com.spotify.Client

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
./install.sh -i debian -l -c Light -N glassy
./tweaks.sh -F
sudo flatpak override --filesystem=xdg-config/gtk-4.0
cd ../WhiteSur-icon-theme
./install.sh
cd ../WhiteSur-cursors
sudo ./install.sh

sudo rm -R /tmp/whitesur 
fi

#ADD Keyboard Shurtcut for Terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Ctrl><Alt>t"

#GRUB FALLOUT SKIN
wget -O- https://github.com/shvchk/fallout-grub-theme/raw/master/install.sh | bash -s -- --lang English

sudo reboot

#TODO: Edit splash for Grub

#TOD0: Davinci_Resolve for Debian
# wget https://swr.cloud.blackmagicdesign.com/DaVinciResolve/v18.6.4/DaVinci_Resolve_18.6.4_Linux.zip?verify=1706867615-BJMMD0Y7fn%2F1TNfWvyHkxQY%2BsTx6m0q7g%2BBcsnumqNw%3D
# sudo apt install fakeroot xorriso 

#TODO: AMDGPU-PRO
# wget https://repo.radeon.com/amdgpu-install/23.40.1/ubuntu/focal/amdgpu-install_6.0.60001-1_all.deb
# wget https://repo.radeon.com/amdgpu-install/23.40.1/ubuntu/jammy/amdgpu-install_6.0.60001-1_all.deb -O amdgpu-install.deb

#TODO: NVIDIA
# Installing the appropriate GPU drivers
# sudo apt-get install nvidia-driver nvidia-opencl-icd libcuda1 libglu1-mesa
# For h.264 and h.265 export you also need the NVIDIA encode library:
# sudo apt-get install libnvidia-encode1