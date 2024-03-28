#! /usr/bin/env bash

installExtensions() {
    ###############################################################################
    #                           Installing Extensions                             #
    ###############################################################################

    whiptail --title " **⚠️  WARNING ⚠️**  " --msgbox "Important: Please stay alert! Click 'INSTALL' in the next extension popups to proceed with the installation.
Your quick action is needed for a smooth setup. Thank you!" 8 78

    print_log "\n###############################################################
##          Installing Gnome Extensions                      ##
###############################################################\n"

    InstallOptions=$(whiptail --separate-output --title "Optional Etensions" --checklist \
        "Choose the Extensions to Install" 20 78 10 \
        "1" "Install No overview at start-up" ON \
        "2" "Install TrayIconsReloaded" ON \
        "3" "Install Dash-To-Dock" ON \
        "4" "Install No-Overview" ON \
        "5" "Install Vitals" OFF \
        "6" "Install Battery Health Charging ( Optional for Laptops )" OFF 3>&1 1>&2 2>&3)

    if [ -z "$InstallOptions" ]; then
        echo "No option was selected (user hit Cancel or unselected all options)"
    else
        for Option in $InstallOptions; do
            echo $InstallOptions
            case "$Option" in
            "1")
                # cd /tmp
                # wget -O no-overviewfthx.zip https://extensions.gnome.org/extension-data/no-overviewfthx.v13.shell-extension.zip
                # gnome-extensions install --force no-overviewfthx.zip
                # rm no-overviewfthx.zip
                busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "no-overview@fthx"
                gnome-extensions enable no-overview@fthx
                ;;
            "2")
                # cd /tmp
                # wget -O trayIconsReloaded.zip https://extensions.gnome.org/extension-data/trayIconsReloadedselfmade.pl.v26.shell-extension.zip
                # gnome-extensions install --force trayIconsReloaded.zip
                # rm trayIconsReloaded.zip
                busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "trayIconsReloaded@selfmade.pl"
                gnome-extensions enable trayIconsReloaded@selfmade.pl
                # busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "ubuntu-appindicators@ubuntu.com"
                # gnome-extensions enable ubuntu-appindicators@ubuntu.com
                ;;
            "3")
                busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "dash-to-dock@micxgx.gmail.com"
                gnome-extensions enable dash-to-dock@micxgx.gmail.com
                ;;
            "4")
                busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "no-overview@fthx"
                gnome-extensions enable no-overview@fthx
                ;;
            "5")
                busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "Vitals@CoreCoding.com"
                gnome-extensions enable Vitals@CoreCoding.com
                ;;
            "6")
                # cd /tmp
                # wget -O BatteryHealthCharging.zip https://extensions.gnome.org/extension-data/Battery-Health-Chargingmaniacx.github.com.v59.shell-extension.zip
                # gnome-extensions install --force BatteryHealthCharging.zip
                # rm BatteryHealthCharging.zip
                busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "Battery-Health-Charging@maniacx.github.com"
                gnome-extensions disable Battery-Health-Charging@maniacx.github.com
                sudo ~/.local/share/gnome-shell/extensions/Battery-Health-Charging\@maniacx.github.com/tool/installer.sh --tool-user $USER_NAME install
                gnome-extensions enable Battery-Health-Charging@maniacx.github.com
                ;;
            *)
                echo "Unsupported item $Options!" >&2
                exit 1
                ;;
            esac
        done
    fi

}
