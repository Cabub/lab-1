#!/bin/sh

if [ "$(id -u)" -ne "0" ]; then
  printf "This script must be run as root!\n"
  exit 1
fi

systemctl disable hostname-derived-machine-id.service 2>/dev/null || true
rm -f /etc/systemd/system/hostname-derived-machine-id.service
rm -f /etc/machine-id
