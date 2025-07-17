#!/bin/sh

if [ "$(id -u)" -ne "0" ]; then
  printf "This script must be run as root!\n"
  exit 1
fi

install -m 755 mac-from-hostname /usr/local/sbin/
install -m 644 mac-address-resolver.service /etc/systemd/system/
systemctl enable mac-address-resolver.service
