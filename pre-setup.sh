#!/bin/bash
set -e
# pre-setup.sh
#
#####################
# some helpful hints:
#####################
#
# to avoid cached script content, it's possible to add "?$(date +%s)" in curl
# that makes debugging easier when script content changes often :-)
# for example:
# curl -sSL "https://raw.githubusercontent.com/Fr3db3rt/some-scripts/master/pre-setup.sh?$(date +%s)" | bash
# see also https://stackoverflow.com/questions/31653271/curl-command-without-using-cache
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

ip a
pacman -Sy openssh
systemctl enable sshd.service
systemctl start sshd.service
passwd root
