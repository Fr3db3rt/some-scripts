# bash
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

echo load german keyboard settings
loadkeys de
echo

echo list and format disk
echo
fdisk -l
echo

fdisk /dev/sda
n
p
1

+20G
n
p
2

+20G
a
1
t
2
82
p
w

