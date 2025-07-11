#! /usr/bin/env bash

installSteamAndTools() {
    print_log "\n#################### Installing tools and Steam ####################\n"
    # Steam Replaced for Flathub Steam.
    sudo flatpak install -y flathub com.valvesoftware.Steam
    installFreedesktopVulkanLayers
    sudo apt clean
    flatpak override --user com.valvesoftware.Steam --env=OBS_VKCAPTURE=1
    flatpak override --user com.valvesoftware.Steam --env=MANGOHUD=1
    flatpak override --user com.valvesoftware.Steam --env=STEAMDECK=1
    flatpak override --user com.valvesoftware.Steam --env=PATH=$PATH:/usr/lib/extensions/vulkan/gamescope/bin
}

installFlatpakApps() {
    InstallOptions=$(whiptail --separate-output --title "Flatpak Apps Options" --checklist \
        "Choose Flatpak Apps to Install" 20 78 12 \
        "1" "Replace Firefox-est for Latest" ON \
        "2" "Install Discord" ON \
        "3" "Install ProtonUp-Qt" OFF \
        "4" "Install Spotify" OFF \
        "5" "Install Bottles" OFF \
        "6" "Install GPU Screen Recorder" OFF \
        "7" "Install OBS-Studio" OFF \
        "8" "Install Helvum" OFF \
        "9" "Install Heroic Launcher" OFF \
        "10" "Install Telegram" OFF \
        "11" "Install Piper (Gaming mouse configuration utility)" OFF \
        "12" "Install OpenRGB (RGB lighting control)" OFF \
        "13" "Install ProtonVPN" OFF 3>&1 1>&2 2>&3)

    if [ -z "$InstallOptions" ]; then
        echo "No option was selected (user hit Cancel or unselected all options)"
    else
        for Option in $InstallOptions; do
            echo $InstallOptions
            case "$Option" in
            "1")
                installFirefoxLatest
                ;;
            "2")
                sudo flatpak install -y flathub com.discordapp.Discord
                sudo flatpak install -y flathub io.github.trigg.discover_overlay
                ;;
            "3")
                sudo flatpak install -y flathub net.davidotek.pupgui2
                ;;
            "4")
                sudo flatpak install -y flathub com.spotify.Client
                ;;
            "5")
                sudo flatpak install -y flathub com.usebottles.bottles
                flatpak override --user com.usebottles.bottles --filesystem=xdg-data/applications
                #Steam non-Flatpak
                flatpak override --user com.usebottles.bottles --filesystem=~/.local/share/Steam
                #Steam Flatpak
                flatpak override --user com.usebottles.bottles --filesystem=~/.var/app/com.valvesoftware.Steam/data/Steam
                installFreedesktopVulkanLayers
                ;;
            "6")
                sudo flatpak install -y flathub com.dec05eba.gpu_screen_recorder
                ;;
            "7")
                installVKCapture
                sudo flatpak install -y com.obsproject.Studio
                sudo flatpak install -y org.freedesktop.Platform.GStreamer.gstreamer-vaapi/x86_64/23.08
                sudo flatpak install -y com.obsproject.Studio.Plugin.Gstreamer/x86_64/stable
                sudo flatpak install -y com.obsproject.Studio.Plugin.BackgroundRemoval
                sudo flatpak install -y org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/24.08
                sudo flatpak install -y com.obsproject.Studio.Plugin.OBSVkCapture/x86_64/stable
                ;;
            "8")
                sudo flatpak install -y flathub org.pipewire.Helvum
                ;;
            "9")
                sudo flatpak install -y flathub com.heroicgameslauncher.hgl
                installFreedesktopVulkanLayers
                ;;
            "10")
                sudo flatpak install -y flathub org.telegram.desktop
                ;;
            "11")
                sudo apt install ratbagd
                sudo flatpak install -y flathub org.freedesktop.Piper
                ;;
            "12")
                sudo flatpak install flathub org.openrgb.OpenRGB
                wget https://openrgb.org/releases/release_0.9/openrgb-udev-install.sh
                chmod +x openrgb-udev-install.sh
                bash openrgb-udev-install.sh
                ;;
            "13")
                sudo extrepo enable protonvpn
                sudo extrepo update protonvpn
                sudo apt update
                sudo apt install proton-vpn-gnome-desktop
                sudo apt install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1 gnome-shell-extension-appindicator
                ;;
            *)
                echo "Unsupported item $Options!" >&2
                exit 1
                ;;
            esac
        done
    fi
}

installVKCapture() {
    sudo apt install -y pkg-config cmake libobs-dev libvulkan-dev libgl-dev libegl-dev libx11-dev libxcb1-dev libwayland-client0 wayland-scanner++
    cd /tmp
    git clone https://github.com/nowrep/obs-vkcapture.git
    cd /tmp/obs-vkcapture
    mkdir build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
    make && sudo make install
}

installFreedesktopVulkanLayers() {
    sudo flatpak install -y org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08
    sudo flatpak install -y org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08
    sudo flatpak install -y org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/24.08
}
