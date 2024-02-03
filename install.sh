#! /usr/bin/env bash

###############################################################################
#                             Debian4Gamers                                   #
###############################################################################

###############################################################################
#                           DECLARED VARIABLES                                #
###############################################################################

if [[ -w "/root" ]]; then
  echo "Do not run the script with root"
  exit
  #USER_NAME=$(id -nu 1000)
else
  USER_NAME=$(whoami)
fi

terminalName="gnome"

###############################################################################
echo -e "###############################################################
##                                                           ##
##                Script to Config Debian 12                 ##
##                GNOME for Gaming Experience,               ##
##                by BenyHdez                                ##
##                                                           ##
###############################################################\n"



###############################################################################
#                      Gnome-Terminal White on Black                          #
###############################################################################
profileID=$(dconf list /org/gnome/terminal/legacy/profiles:/)
echo $profileID
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/$profileID use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/$profileID background-color 'rgb(0,0,0)' 

###############################################################################
#                             Add User to sudoers                             #
###############################################################################
if [[ -e /etc/sudoers.d/$USER_NAME ]]; then
  echo -e "Hello $USER_NAME your User is already a Sudoers:\n"
  echo -e "Removing $USER_NAME from Sudoers and exit"
  sudo rm /etc/sudoers.d/$USER_NAME
  exit
else
echo -e "###############################################################
    Hello $USER_NAME, enter the ROOT password 
    to add your user_name:<'$USER_NAME'> to the Sudoers list:                  
###############################################################\n"
su - root -c 'echo "'${USER_NAME}'  ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/'${USER_NAME}''
fi


###############################################################################
#                   Updating all the system                                   #
###############################################################################
echo -e "\n###############################################################
    !!Hey $USER_NAME Insert now your USER password         
    ( you are a sudoer now )!!                             
###############################################################\n"

sudo dpkg --add-architecture i386
sudo rm /etc/apt/sources.list
sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/bookworm_sources.list -O /etc/apt/sources.list

echo -e "\n###############################################################
##    Upgrading the entire system preparation...             ##
###############################################################\n"
sudo apt update
sudo apt dist-upgrade -y

echo -e "\n###############################################################
##    Installing firmwares, tools and Steam                  ##
###############################################################\n"
sudo apt install -y neofetch firmware-amd-graphics mangohud git mesa-opencl-icd steam-installer bash-completion vulkan-tools
sudo apt clean


###############################################################################
#               Upgrading MESA VULKAN DRIVERS from Testing branch             #
###############################################################################
echo -e "\n###############################################################
##   Installing MESA VULKAN DRIVERS whit rom amdgpu-install  ##
###############################################################\n"
echo "deb http://deb.debian.org/debian testing main" | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt install -y mesa-vulkan-drivers

###############################################################################
#                   Rollback - remove Testing branch                          #
###############################################################################
echo -e "###############################################################
##             Rollingback -> removing Testing branch        ##
###############################################################\n"
sudo rm /etc/apt/sources.list
sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/bookworm_sources.list -O /etc/apt/sources.list
sudo apt update

###############################################################################
#                           Installing Extensions                             #
###############################################################################

echo -e "\n###############################################################
##          Downloading Gnome Extensions                     ##
###############################################################\n"
sudo apt install -y lm-sensors gnome-shell-extension-dashtodock gnome-shell-extension-appindicator
sudo apt clean

#Install External Extensions
cd /tmp
wget -O no-overviewfthx.zip https://extensions.gnome.org/extension-data/no-overviewfthx.v13.shell-extension.zip
gnome-extensions install --force no-overviewfthx.zip
rm no-overviewfthx.zip

echo -e "\n###############################################################
##          Installing Gnome Extensions                      ##
###############################################################\n"

whiptail --title " **⚠️  WARNING ⚠️**  " --msgbox "Important: Please stay alert! Click 'INSTALL' in the next extension popups to proceed with the installation.
Your quick action is needed for a smooth setup. Thank you!" 8 78
#Installing Extensions
if whiptail --title "Ubuntu-Appindicators" --yesno "Do you want to install ubuntu-appindicators extension?" 8 78; then
  busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "ubuntu-appindicators@ubuntu.com"
  gnome-extensions enable ubuntu-appindicators@ubuntu.com
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


###############################################################################
#                   Installing Flatpak and Flathub Store                      #
###############################################################################
echo -e "\n###############################################################
##           Installing Flatpak and Flathub Store            ##
###############################################################\n"

#TODO: whiptail Selector for all flatpaks
sudo apt install -y flatpak gnome-software-plugin-flatpak
sudo apt clean 
## sudo apt install plasma-discover-backend-flatpak  ## TODO: Identify if plasma-discover is installed
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


#Install Discord, Spotify and ProtonUp-Qt
echo -e "\n###############################################################
##         Installing Discord, Spotify and ProtonUp-Qt       ##
###############################################################\n"
sudo flatpak install -y flathub com.discordapp.Discord
sudo flatpak install -y flathub net.davidotek.pupgui2
sudo flatpak install -y flathub com.spotify.Client


###############################################################################
#                   Installing WhiteSur themes                                #
###############################################################################
if whiptail --title "Installing WhiteSur themes" --yesno "Do you want to install WhiteSur?" 8 78; then
  #WhiteSur gtk Installation

echo -e "\n###############################################################
##        Installing WhiteSur gtk,icons,cursors themes       ##
###############################################################\n"

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
  ./WhiteSur-cursors/install.sh
  sudo sudo rm -R WhiteSur-cursors

###############################################################################
#             Setting up WhiteSur gtk,icons,cursors themes                    #
###############################################################################

echo -e "\n###############################################################
##        Setting up WhiteSur gtk,icons,cursors themes       ##
###############################################################\n"

  gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'
  gsettings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors'
  gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Light'
  gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur'
  gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark'
  
  #TODO: Move Window Titlebars placement to the left
fi

#Adding Keybinding for 
###############################################################################
#                          Setting up Keybindings                             #
#                        Terminal and show-desktop                            #
###############################################################################
if whiptail --title "Setting up Keybindings" --yesno "Do you want to setting up my keybindings configuration?" 8 78; then
echo -e "\n###############################################################
##    Setting up Keybindings for Terminal and Show-Desktop   ##
###############################################################\n"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "$terminalName-terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Ctrl><Alt>t"
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
fi

#Disabling Hot Corner
if whiptail --title "Disabling Hot Corner" --yesno "Do you wish to disable the Hot Corner?" 8 78; then
echo -e "\n###############################################################
##               Disabling Gnome-Shell Hot Corner            ##
###############################################################\n"
gsettings set org.gnome.desktop.interface enable-hot-corners false
fi

#GRUB FALLOUT THEME
if whiptail --title "GRUB FALLOUT THEME" --yesno "Are you interested in installing the GRUB theme 'shvchk/grub-theme' from GitHub?" 8 78; then
echo -e "\n###############################################################
##            Setting up fallout-grub-theme English          ##
###############################################################\n"
wget -O- https://github.com/shvchk/fallout-grub-theme/raw/master/install.sh | bash
fi

###############################################################################
#                         Setting up xfce4-terminal                           #
###############################################################################
if whiptail --title "xfce4-terminal" --yesno "Are you interested in installing the xfce4-terminal? This terminal have a better look and performance" 8 78; then
echo -e "\n###############################################################
##                  Setting up xfce4-terminal                ##
###############################################################\n"
sudo apt install xfce4-terminal -y
sudo apt clean
terminalName="xfce4"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "$terminalName-terminal"
sudo apt remove --purge gnome-terminal -y
  if [[ -e ~/.config/xfce4/terminal/terminalrc ]]; then
    wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/terminalrc -O ~/.config/xfce4/terminal/terminalrc
  else
    mkdir -p ~/.config/xfce4/terminal/
    wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/terminalrc -O ~/.config/xfce4/terminal/terminalrc
  fi

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