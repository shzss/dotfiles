#!/bin/bash
echo "creating partitions" # partition here first /boot on 1 and luksdev on 2
parted -s /dev/nvme0n1 mklabel gpt
parted -s -a optimal /dev/nvme0n1 mkpart '""' fat32 1MiB 512MiB
parted /dev/nvme0n1 set 1 boot on
parted /dev/nvme0n1 set 1 esp on
parted -s -a optimal /dev/nvme0n1 mkpart '""' 512MiB 100%

echo "encrypting disk"
cryptsetup luksFormat /dev/nvme0n1p3
cryptsetup open /dev/nvme0n1p3 lvm

echo "creating LVM on encrypted disk"
pvcreate /dev/mapper/cryptlvm
vgcreate RootVolGroup /dev/mapper/cryptlvm
lvcreate -L 4G volgroup -n swap
lvcreate -l 100%FREE volgroup -n root
lvreduce -y -q -L -256M volgroup/root

echo "activating volume groups"
vgchange -ay

echo "formatting volumes"
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.ext4 /dev/volgroup/root
mkswap /dev/volgroup/swap

echo "mounting volumes"
mount /dev/volgroup/root /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot
swapon /dev/volgroup/swap

echo "installing base system"
pacstrap -K /mnt base linux linux-firmware intel-ucode lvm2 sudo
genfstab -U /mnt >> /mnt/etc/fstab

cp ./chroot.sh /mnt/chroot.sh
arch-chroot /mnt /chroot.sh
rm /mnt/after_chroot.sh

echo "rebooting"
reboot
