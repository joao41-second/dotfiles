y="--noconfirm"

pacman -S bluez bluez-utils blueman $y

systemctl enable bluetooth
systemctl start bluetooth 

pacman -S rofi-wayland $y

pacman -S network-manager-applet $y

sudo pacman -S network-manager-applet $y

rfkill unblock all
