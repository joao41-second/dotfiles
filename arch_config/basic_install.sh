
comfim="--noconfirm"

pacman -Syu $confim
pacman -s linux-firmware wirless_tools wpa_supplicant  $confim
pacman -S base-devel --noconfirm 
pacman -S linux-headers 
pacman -S git --noconfirm 
pacman -S networkmanager --noconfirm 
systemctl enable NetworkManager  
systemctl start NetworkManager
pacman -S vim --noconfirm 
pacman -S tmux --noconfirm 
pacman -S openssh --noconfirm 
syatemctl stop sshd
systemctl enable sshd
systemctl start sshd
pacman -S hyprland kitty waybar wofi --noconfirm 
mkdir -p ~/.config/hypr
cp /etc/xdg/hypr/hyprland.conf ~/.config/hypr/
pacman -S nvidia-dkms nvidia-utils 

mkidir -fr  /home/joao41/git/
git clone https://aur.archlinux.org/yay.git /home/joao41/git/yay

cd /home/joao41/git/yay && makepkg -si
