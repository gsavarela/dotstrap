#!/bin/bash

welcome() {
  echo "Welcome, to Dotstrap, this script will bootstrap Arch like linux distributions with programs and development tools to increase your productivity."
  echo "For this installer to work you will need to have an active internet connection and allow this program to run as root."

  # TODO solve this
  # pacman --noconfirm --needed -Sy archlinux-keyring > /dev/null 2>&1 || echo "MUST RUN AS ROOT USER"
}

# 1) USER
set_nopasswd_wheel() {
  sed -i "/#DOTSTRAP/d" /etc/sudoers
  echo "%wheel ALL=(ALL) NOPASSWD: ALL #DOTSTRAP" >> /etc/sudoers
}

add_user() {
  echo -n "Enter new username: "
  read username
  # TODO solve this
  # if id -u $username >/dev/null 2>$1; then
  #   echo "User already exists!"
  # else
    echo -n "Enter password for new user: "
    read -s password
    useradd -m -g wheel "$username"
    echo "$password" | passwd "$username" --stdin
  # fi
}

choose_user() {
  echo "Enter existing username: "
  read username
}

add_or_choose_user() {
  while true; do
    echo "Do you need to create a user?"
    echo "(y) create a user"
    echo "(n) choose an existing user"
    echo "(c) cancel"
    read -p "> " ync
      case $ync in
          [Yy]* ) add_user; break;;
          [Nn]* ) choose_user; break;;
          [Cc]* ) exit;;
          * ) echo " ";;
      esac
  done
}



# 2) BASICS REQUIRED.
install_basics() {
  pacman --noconfirm --needed -Sy $(< ./packages/base.list)
}


# 3) NETWORK SYSTEMD
# Determine automatically
start_network_service() {
  # Verify PID1
  INIT=$(realpath /sbin/init | awk -F/ '{print $NF}')

  # while true; do
  echo "$INIT found"
  echo "(y) Activate network using $INIT."
  echo "(c) cancel"
  read -p "> " yc
  case $ync in
    [Yy]* ) start_network_systemd_service; exit;;
    [Cc]* ) exit;;
    * ) echo " ";;
  esac
  # done

}

start_network_systemd_service() {
  systemctl start NetworkManager
  systemctl enable NetworkManager
}

# TODO: Handle runit
# start_network_runit_service() {
#  pacman --noconfirm --needed -Sy $(< ./packages/runit.list)
# }

# 4) OPTIONAL
install_developtools() {
  while true; do
    echo "Do you want to install devops?"
    cat ./packages/devops.list
    echo "(y) install devops"
    echo "(n) don't install devops"
    read -p "> " ync
      case $ync in
          [Yy]* ) sudo -u "$username" pacman  --noconfirm --needed -Sy $(< ./packages/devops.list); break;;
          [Nn]* ) echo "Not installing devops"; break;;
          * ) echo " ";;
      esac
  done
}

install_tools() {
  while true; do
    echo "Do you want to install tools?"
    cat ./packages/tools.list
    echo "(y) install tools"
    echo "(n) don't install tools"
    read -p "> " ync
      case $ync in
          [Yy]* ) sudo -u "$username" pacman  --noconfirm --needed -Sy $(< ./packages/tools.list); break;;
          [Nn]* ) echo "Not installing tools"; break;;
          * ) echo " ";;
      esac
  done
}

install_productivity() {
  while true; do
    echo "Do you want to install productivity?"
    cat ./packages/productivity.list
    echo "(y) install productivity"
    echo "(n) don't install productivity"
    read -p "> " ync
      case $ync in
          [Yy]* ) sudo -u "$username" pacman  --noconfirm --needed -Sy $(< ./packages/productivity.list); break;;
          [Nn]* ) echo "Not installing productivity"; break;;
          * ) echo " ";;
      esac
  done
}

install_browsers() {
  while true; do
    echo "Do you want to install browsers?"
    cat ./packages/browsers.list
    echo "(y) install browsers"
    echo "(n) don't install browsers"
    read -p "> " ync
      case $ync in
          [Yy]* ) sudo -u "$username" pacman  --noconfirm --needed -Sy $(< ./packages/browsers.list); break;;
          [Nn]* ) echo "Not installing browsers"; break;;
          * ) echo " ";;
      esac
  done
}

welcome
set_nopasswd_wheel
add_or_choose_user
install_basics
start_network_service
install_devops
install_tools
install_productivity
install_browsers
# make_home_directories_for_user
# polybar i3 fontconfig alacritty

# wallpapers
# xprofile
# zsh
# zprofile
