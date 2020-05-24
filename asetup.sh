#!/bin/bash
set -e
# asetup.sh
#
#####################
# some helpful hints:
#####################
#
# curl -sSL "https://raw.githubusercontent.com/Fr3db3rt/some-scripts/master/asetup.sh?$(date +%s)" | bash
# param ?$(date +%s) is used to avoid cached script content in asetup.sh
# see https://stackoverflow.com/questions/31653271/curl-command-without-using-cache
#
# in order to use scripting and editing more comfortabel:
# for instance I used a virtual machine in ESXi, which I can log in from,
# but then I was left out without copy and paste and things like that,
# I prepared it for ssh with just a few keystrokes
#
# 1. get the IP-Address (DHCPed)
# 2. install ssh with pacman
# 3. prepare ssh server
# 4. start ssh daemon
# 5. set the password for root (you can't login without password!)
#
# ip a
# pacman -Sy openssh
# systemctl enable sshd.service
# systemctl start sshd.service
# passwd root
#
# now you can login with ssh and comfortably continue all the next steps
#

echo
echo for more information how I created asetup.sh read source at 
echo https://wiki.archlinux.de/title/Anleitung_f%C3%BCr_Einsteiger
echo

echo -----------------------------
echo load german keyboard settings
loadkeys de
echo -----------------------------
echo

do_fdisk() {
# This will always execute
echo ---------------------
echo list and prepare disk
fdisk -l
echo ---------------------
echo
fdisk /dev/sda
n
p
1

+20G
n
p
2

+2G
a
1
t
2
82
p
w
echo
}

do_fdisk

echo
echo ---------------------
echo format root partition
echo ---------------------
mkfs.ext4 -L p_arch /dev/sda1
echo

echo
echo ---------------------
echo format swap partition
echo ---------------------
mkswap -L p_swap /dev/sda2
echo

echo
echo --------------------
echo mount root partition
echo --------------------
mount -L p_arch /mnt
echo

echo
echo --------------------
echo mount swap partition
echo --------------------
swapon -L p_swap
echo

# config proxy server (if any)
# if proxy is used for ftp or http(s) connection:
#export http_proxy="http://<servername>:<port>"
#export https_proxy="https://<servername>:<port>"
#export ftp_proxy="ftp://<servername>:<port>"

echo
echo ------------
echo test network
echo ------------
ping -c3 www.archlinux.de
echo

echo
echo -------------------
echo install base system
echo -------------------
echo
#cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
#nano /etc/pacman.d/mirrorlist
pacman -Sy
echo
pacman -Sy reflector
echo
reflector --latest 5 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
echo
pacstrap /mnt base base-devel linux linux-firmware nano mc
echo
pacman --root /mnt -S dhcpcd
echo
pacman --root /mnt -S bash-completion
echo
genfstab -Up /mnt > /mnt/etc/fstab
echo
echo -------------
cat /mnt/etc/fstab
echo -------------
echo
arch-chroot /mnt/
echo
echo ------------------------------------------------------------------
echo

echo
echo manage > /etc/hostname
echo LANG=de_DE.UTF-8 > /etc/locale.conf
echo
locale-gen
echo
echo KEYMAP=de-latin1 > /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf
echo
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo
mkinitcpio -p linux
echo
passwd
echo
pacman -S grub
echo
grub-install /dev/sda
echo
grub-mkconfig -o /boot/grub/grub.cfg
echo
echo ===========================================
echo ===========================================
echo ===========================================
exit
umount /dev/sda1
echo
echo reboot now!
echo
