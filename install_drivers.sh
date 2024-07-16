#! /usr/bin/env bash

installNvidiaDrivers() {
    # Search for graphics cards in the system using lspci
    gpu_info=$(lspci | grep -i vga)
    # Check GPU manufacturer
    case "$gpu_info" in
    *AMD* | *amd*)
        print_log "**⚠️ An AMD graphics card was detected. Noting to do... ⚠️**"
        ;;
    *NVIDIA* | *nvidia*)
        print_log "**⚠️ A NVIDIA graphics card was detected. ⚠️**"
        print_log "Installing the appropriate GPU drivers..."
        sudo apt install -y nvidia-driver firmware-misc-nonfree nvidia-opencl-icd libcuda1 libglu1-mesa
        # For h.264 and h.265 export you also need the NVIDIA encode library:
        sudo apt install -y libnvidia-encode1
        sudo flatpak update
        ;;
    *Intel* | *intel*)
        print_log "**⚠️ An Intel GPU was detected. Noting to do... ⚠️**"
        ;;
    *)
        print_log "**⚠️ Unknown or no dedicated GPU detected.  Noting to do... ⚠️**"
        ;;
    esac
}
