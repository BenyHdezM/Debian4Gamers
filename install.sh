#! /usr/bin/env bash
echo -e "##########################################
##                                      ##
##      Script to Config Debian 12      ##
##      GNOME for Gaming Experience,    ##
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
echo -e "$USER_NAME Insert now your USER password ( you are a sudoer now )\n" 
sudo dpkg --add-architecture i386
sudo rm /etc/apt/sources.list
sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/bookworm_sources.list -O /etc/apt/sources.list
sudo apt update
sudo apt dist-upgrade
sudo apt install -y firmware-amd-graphics mangohud git mesa-opencl-icd steam-installer

#Upgrading MESA VULKAN DRIVERS from Debian Testing branch
echo "deb http://deb.debian.org/debian testing main" | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt install -y mesa-vulkan-drivers

#Rollback - remove Testing branch
sudo rm /etc/apt/sources.list
sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/bookworm_sources.list -O /etc/apt/sources.list


#Install Extensios
sudo apt install -y lm-sensors gnome-shell-extension-dashtodock gnome-shell-extension-appindicator
sudo apt update

# #Enable Extensions
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable ubuntu-appindicators@ubuntu.com
gnome-extensions enable dash-to-dock@micxgx.gmail.com

#Install External Extensions
cd /tmp
wget -O no-overviewfthx.zip https://extensions.gnome.org/extension-data/no-overviewfthx.v13.shell-extension.zip
gnome-extensions install --force no-overviewfthx.zip
gnome-extensions enable no-overview@fthx
rm no-overviewfthx.zip

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
./install.sh -i debian -l -N glassy
rm ~/.config/gtk-4.0/gtk.css
ln -s ~/.config/gtk-4.0/gtk-Light.css ~/.config/gtk-4.0/gtk.css
./tweaks.sh -F
sudo flatpak override --filesystem=xdg-config/gtk-4.0
cd ../WhiteSur-icon-theme
./install.sh
cd ../WhiteSur-cursors
sudo ./install.sh

sudo rm -R /tmp/whitesur 

#Set gtk themes, icons and cursor
settings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors'
settings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Light'
settings set org.gnome.desktop.interface icon-theme 'WhiteSur'
settings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark'
fi

#TODO: Set gnome-terminal background color

#Adding Keybinding for Terminal and show-desktop
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Ctrl><Alt>t"
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"

#Disable Hot Corner
gsettings set org.gnome.desktop.interface enable-hot-corners false

#GRUB FALLOUT SKIN
wget -O- https://github.com/shvchk/fallout-grub-theme/raw/master/install.sh | bash -s -- --lang English

sudo reboot

#TODO: Edit splash for Grub


#TODO: SET AMDGPU-PRO 
# wget https://repo.radeon.com/amdgpu-install/23.40.1/ubuntu/focal/amdgpu-install_6.0.60001-1_all.deb
# wget https://repo.radeon.com/amdgpu-install/23.40.1/ubuntu/jammy/amdgpu-install_6.0.60001-1_all.deb -O amdgpu-install.deb

#TODO: NVIDIA Support
# Installing the appropriate GPU drivers
# sudo apt-get install nvidia-driver nvidia-opencl-icd libcuda1 libglu1-mesa
# For h.264 and h.265 export you also need the NVIDIA encode library:
# sudo apt-get install libnvidia-encode1


#TOD0: Davinci_Resolve for Debian
# wget https://swr.cloud.blackmagicdesign.com/DaVinciResolve/v18.6.4/DaVinci_Resolve_18.6.4_Linux.zip?verify=1706867615-BJMMD0Y7fn%2F1TNfWvyHkxQY%2BsTx6m0q7g%2BBcsnumqNw%3D
# sudo apt install fakeroot xorriso 