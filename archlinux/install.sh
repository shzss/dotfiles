#!/bin/bash
set -e

echo "setting swedish keymaps for installation"
loadkeys sv-latin1

echo "setting time from NTP"
timedatectl set-ntp true

echo "creating disk label gpt"
parted -s /dev/nvme0n1 mklabel gpt

echo "creating boot partition"
parted -s -a optimal /dev/nvme0n1 mkpart '"boot"' fat32 1MiB 512MiB
parted /dev/nvme0n1 set 1 boot on

echo "creating efi partition"
parted -s -a optimal /dev/nvme0n1 mkpart '"efi"' ext4 512MiB 1024MiB
parted /dev/nvme0n1 set 2 esp on

echo "creating lvm partition"
parted -s -a optimal /dev/nvme0n1 mkpart '"lvm"' ext4 1024MiB 100%

echo "encrypting disk"
cryptsetup luksFormat /dev/nvme0n1p3
cryptsetup open /dev/nvme0n1p3 lvm

echo "creating LVM on encrypted disk"
pvcreate /dev/mapper/lvm
vgcreate volgroup0 /dev/mapper/lvm
lvcreate -L 4G RootVolGroup -n swap
lvcreate -L 30G volgroup0 -n root
lvcreate -L 100%FREE volgroup0 -n home
lvreduce -y -q -L -256M volgroup0/home

echo "adding modules for Kernel"
modprobe dm_mod

echo "activate all volume groups"
vgchange -ay

echo "formatting volumes"
mkfs.ext4 /dev/volgroup0/root
mkfs.ext4 /dev/volgroup0/home
mkswap /dev/volgroup0/swap

echo "mounting volumes"
mount /dev/volgroup0/home /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/home
mount /dev/volgroup0/root /mnt
mount --mkdir /dev/nvme0n1p2 /mnt/boot
swapon /dev/RootVolGroup/swap

echo "installing base system"
pacstrap -K /mnt base linux linux-firmware intel-ucode lvm2 sudo
genfstab -U /mnt >> /mnt/etc/fstab

cp ./chroot.sh /mnt/chroot.sh
arch-chroot /mnt /chroot.sh
rm /mnt/after_chroot.sh

echo "rebooting"
reboot
