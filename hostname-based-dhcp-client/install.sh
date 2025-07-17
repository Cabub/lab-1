#!/bin/sh

if [ "$(id -u)" -ne "0" ]; then
  printf "This script must be run as root!\n"
  exit 1
fi

install -m 755 hostname-hash /usr/local/sbin/
install -m 644 hostname-based-dhcp-client.service /etc/systemd/system/
systemctl enable hostname-based-dhcp-client.service
