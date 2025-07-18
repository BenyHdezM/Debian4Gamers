#! /usr/bin/env bash

installGnomeTheme() {
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
        ./WhiteSur-gtk-theme/install.sh --shell -i debian -l --round
        ./WhiteSur-gtk-theme/tweaks.sh -F
        ./WhiteSur-gtk-theme/tweaks.sh -f monterey
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
        gsettings set org.gnome.desktop.interface clock-format '12h'
        gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

        wget https://raw.githubusercontent.com/BenyHdezM/Debian4Gamers/main/images/sierra.jpg -O $HOME/sierra.jpg
        ruta_imagen="$HOME/sierra.jpg"
        gsettings set org.gnome.desktop.background picture-uri "file://${ruta_imagen}"

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
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Ctrl><Alt>t"
        gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
    fi

    if whiptail --title "Setting Input Source" --yesno "Do you have an English Keyboard and do you want the letter Ñ using <alt+n> ?" 10 78; then
        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"
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

}
