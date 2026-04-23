
sudo pacman -S pipewire pipewire-pulse wireplumber pavucontrol --noconfirm
systemctl --user  enable --now wireplumber

systemctl --user  start --now wireplumber
