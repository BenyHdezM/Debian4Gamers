#! /usr/bin/env bash

installExtensions() {
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
}
