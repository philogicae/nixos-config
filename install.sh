#!/usr/bin/env bash

init() {
    # Vars
    HOST='vm'
    CURRENT_USERNAME='frostphoenix'
    username="philogicae"

    # Colors
    NORMAL=$(tput sgr0)
    WHITE=$(tput setaf 7)
    BLACK=$(tput setaf 0)
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    BRIGHT=$(tput bold)
    UNDERLINE=$(tput smul)
}

print_header() {
    echo -E "$CYAN
  ____   _      _  _                _                                       
 |  _ \ | |__  (_)| |  ___    __ _ (_)  ___  __ _   ___                     
 | |_) || '_ \ | || | / _ \  / _' || | / __|/ _' | / _ \                    
 |  __/ | | | || || || (_) || (_| || || (__| (_| ||  __/                    
 |_|    |_| |_||_||_| \___/  \__, ||_| \___|\__,_| \___|                    
                             |___/                                          
  _   _  _         ___         ___              _          _  _             
 | \ | |(_)__  __ / _ \  ___  |_ _| _ __   ___ | |_  __ _ | || |  ___  _ __ 
 |  \| || |\ \/ /| | | |/ __|  | | | '_ \ / __|| __|/ _' || || | / _ \| '__|
 | |\  || | >  < | |_| |\__ \  | | | | | |\__ \| |_| (_| || || ||  __/| |   
 |_| \_||_|/_/\_\ \___/ |___/ |___||_| |_||___/ \__|\__,_||_||_| \___||_| 

                  $BLUE https://github.com/philogicae $RED 
      ! To make sure everything runs correctly DONT run as root ! $GREEN
                        -> './install.sh' $NORMAL

    "
}

set_username() {
    sed -i -e "s/${CURRENT_USERNAME}/${username}/g" ./flake.nix
    sed -i -e "s/${CURRENT_USERNAME}/${username}/g" ./modules/home/audacious.nix
}

aseprite() {
    # whether to install aseprite or not
    echo -en "Disable ${GREEN}Aseprite${NORMAL} (faster install) ? [${GREEN}y${NORMAL}/${RED}n${NORMAL}]: "
    read -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi
    sed -i '3s/  /  # /' modules/home/aseprite/aseprite.nix
}

install() {
    echo -e "\n${RED}START INSTALL PHASE${NORMAL}\n"

    # Create basic directories
    echo -e "Creating folders:"
    echo -e "    - ${MAGENTA}~/Music${NORMAL}"
    echo -e "    - ${MAGENTA}~/Documents${NORMAL}"
    echo -e "    - ${MAGENTA}~/Pictures/wallpapers/others${NORMAL}"
    mkdir -p ~/Music
    mkdir -p ~/Documents
    mkdir -p ~/Pictures/wallpapers/others

    # Copy the wallpapers
    echo -e "Copying all ${MAGENTA}wallpapers${NORMAL}"
    cp -r wallpapers/wallpaper.png ~/Pictures/wallpapers
    cp -r wallpapers/otherWallpaper/gruvbox/* ~/Pictures/wallpapers/others/
    cp -r wallpapers/otherWallpaper/nixos/* ~/Pictures/wallpapers/others/

    # Get the hardware configuration
    echo -e "Copying ${MAGENTA}/etc/nixos/hardware-configuration.nix${NORMAL} to ${MAGENTA}./hosts/${HOST}/${NORMAL}\n"
    cp /etc/nixos/hardware-configuration.nix hosts/${HOST}/hardware-configuration.nix

    # Build the system (flakes + home manager)
    echo -e "\nBuilding the system...\n"
    sudo nixos-rebuild switch --flake .#${HOST} --impure
}

main() {
    init
    print_header
    set_username
    aseprite
    install
}

main && exit 0
