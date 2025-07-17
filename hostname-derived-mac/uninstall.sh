#!/bin/sh

if [ "$(id -u)" -ne "0" ]; then
  printf "This script must be run as root!\n"
  exit 1
fi

systemctl disable hostname-derived-mac@*.service 2>/dev/null || true
rm -f /etc/systemd/system/hostname-derived-mac@.service
rm -f /etc/systemd/network/10-hostname-derived-mac-*.link
