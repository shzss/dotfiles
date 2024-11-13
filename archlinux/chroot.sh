#!/bin/bash
ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

echo "setting up keymaps"
echo "KEYMAP=sv-latin1" > /etc/vconsole.conf
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo -e "en_US.UTF-8 UTF-8\nsv_SE.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

mkdir -p /etc/X11/xorg.conf.d
cat <<EOT >> /etc/X11/xorg.conf.d/00-keyboard.conf
# Written by systemd-localed(8), read by systemd-localed and Xorg. It's
# probably wise not to edit this file manually. Use localectl(1) to
# instruct systemd-localed to update it.
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "se"
        Option "XkbModel" "pc105"
        Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection
EOT

echo "configuring mkinitcpio"
HOOKS="HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)"
sed -i "s/^HOOKS=.*/$HOOKS/" /etc/mkinitcpio.conf
mkinitcpio -P 

echo "installing dm and wm"
pacman --noconfirm -S lightdm lightdm-gtk-greeter i3-wm i3status dmenu

echo "installing network tools"
pacman --noconfirm -S dialog netctl dhcpcd

echo "installing tools"
pacman --noconfirm -S alacritty neovim

systemctl enable lightdm
systemctl enable fstrim.timer

echo "setup bootloader systemd-boot"
bootctl install
echo -e "default arch.conf\ntimeout 4\nconsole-mode max\neditor no" > /boot/loader/loader.conf
cat <<EOT >> /boot/loader/entries/arch.conf
title Arch Linux Encrypted
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=%%UUID%%:cryptlvm:allow-discards root=/dev/volgroup/root quiet rw
EOT

DISKUUID=$(blkid -s UUID -o value /dev/nvme0n1p3)
sed -i "s/%%UUID%%/$DISKUUID/" /boot/loader/entries/arch.conf

echo "setup root password"
passwd

echo "setup username"
read newusername
useradd -m -G wheel "$newusername"

echo "setup user password"
passwd "$newusername"
