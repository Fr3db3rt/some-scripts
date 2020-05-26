#!/bin/bash
set -e
sleep 3
# arch-setup.sh for Arch Linux installation
#
#####################
# some helpful hints:
#####################
#
# to avoid cached script content with cURL:
# - it's possible to use -H 'Cache-Control: no-cache'
# - and also add querystring parameter like "?$RANDOM"
# that makes debugging easier when script content changes often :-)
# for example:
# curl -H "Cache-Control: no-cache" -sSL "https://raw.githubusercontent.com/Fr3db3rt/some-scripts/master/arch-setup.sh?$RANDOM" | bash
# see https://stackoverflow.com/questions/31653271/curl-command-without-using-cache
#
# in order to use this scripting and editing more comfortabel:
# for instance I used a virtual machine in ESXi, which I can log in from,
# but then I was left out without copy and paste and things like that,
# so I prepared it for ssh with just a few keystrokes
#
# look here:
# ->>> curl -sSL https://raw.githubusercontent.com/Fr3db3rt/some-scripts/master/pre-setup.sh | bash
# then you can login with ssh and comfortably continue all the next steps
#

echo
echo for more information how I created pre-setup.sh read source at 
echo https://wiki.archlinux.de/title/Anleitung_f%C3%BCr_Einsteiger
echo

echo -----------------------------
echo load german keyboard settings
loadkeys de
echo -----------------------------
echo
timedatectl set-ntp true
# to ensure the system clock is accurate
echo ---------------------
echo list and prepare disk
fdisk -l
sleep 3
echo ---------------------

echo -e "o\nn\np\n1\n\n+10G\nn\np\n2\n\n+1G\na\n1\nt\n2\n82\nw\n" | fdisk /dev/sda

echo
sleep 3
echo
echo -------------------------------
echo format and mount root partition
echo -------------------------------
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
echo
echo ------------------------------------
echo format and initialize swap partition
echo ------------------------------------
mkswap /dev/sda2
swapon /dev/sda2
echo
sleep 5
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
sleep 3
echo
echo -----------------------
echo sort and select mirrors
echo -----------------------
echo
pacman -Sy --noconfirm 
echo
pacman -Sy --noconfirm reflector
echo
reflector --latest 10 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
echo
pacstrap /mnt base linux linux-firmware
echo
pacman --root /mnt -Sy --noconfirm dhcpcd bash-completion nano mc openssh
echo
sleep 3
echo
genfstab -U /mnt >> /mnt/etc/fstab
echo
echo -------------
cat /mnt/etc/fstab
echo -------------
sleep 3
echo
arch-chroot /mnt
echo
echo ------------------------------------------------------------------
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo LANG=de_DE.UTF-8 >> /etc/locale.conf
locale-gen
echo KEYMAP=de-latin1 >> /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf
echo manage-01 >> /etc/hostname
echo 127.0.0.1 localhost >> /etc/hosts
echo ::1 localhost >> /etc/hosts
echo 127.0.1.1 manage-01.localdomain manage-01 >> /etc/hosts
sleep 5
systemctl enable sshd.service
systemctl start sshd.service
systemctl status sshd.service
sleep 3
mkinitcpio -p linux
echo
pacman -Sy --noconfirm grub
echo
grub-install /dev/sda
echo
grub-mkconfig -o /boot/grub/grub.cfg
sleep 3
echo
echo ========================
echo ========================
echo ========================
echo Do not forget to set ...
echo 1st - the new password
echo *** while in chroot! ***
echo 2nd - then exit chroot
echo ...
echo 3rd - umount /dev/sda1
echo ...
echo 4th - reboot now
echo ========================
echo ========================
echo ========================
sleep 3
echo
