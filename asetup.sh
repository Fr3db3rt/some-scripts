echo for more information read source at 
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
