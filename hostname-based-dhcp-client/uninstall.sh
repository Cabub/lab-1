#!/bin/sh

if [ "$(id -u)" -ne "0" ]; then
  printf "This script must be run as root!\n"
  exit 1
fi

systemctl disable hostname-based-dhcp-client.service 2>/dev/null || true
rm -f /etc/systemd/system/hostname-based-dhcp-client.service
rm -f /usr/local/sbin/hostname-hash
rm -f /etc/systemd/network/10-mac-*.link
rm -f /etc/machine-id
