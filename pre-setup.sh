#!/bin/bash
set -e
# pre-setup.sh for Arch Linux installation
# downloads ...
curl -o arch-setup.sh -H "Cache-Control: no-cache" -sSL "https://raw.githubusercontent.com/Fr3db3rt/some-scripts/master/arch-setup.sh?$RANDOM"#
# and prepares for ssh connections
#
#####################
# some helpful hints:
#####################
# to avoid cached script content with cURL:
# - it's possible to use -H "Cache-Control: no-cache"
# - and also add querystring parameter like "?$RANDOM"
# that makes debugging easier when script content changes often :-)
# for example:
# curl -H "Cache-Control: no-cache" -sSL "https://raw.githubusercontent.com/Fr3db3rt/some-scripts/master/pre-setup.sh?$RANDOM" | bash
# see https://stackoverflow.com/questions/31653271/curl-command-without-using-cache
#
# in order to use scripting and editing more comfortable:
# for instance I used a virtual machine in ESXi, which I can log in from,
# but then I was left out without copy and paste and things like that,
# I prepared it for ssh with just a few keystrokes
#
# 1. get the IP-Address (DHCPed)
# 2. install ssh with pacman
# 3. prepare ssh server
# 4. start ssh daemon
# 5. set the password for root (you can't login without password!)

loadkeys de
ip a
pacman -Sy --noconfirm openssh
systemctl enable sshd.service
systemctl start sshd.service
systemctl status sshd.service
echo ...
echo change password now with
echo passwd root
echo
passwd root
