#!/bin/sh

if [ "$(id -u)" -ne "0" ]; then
  printf "This script must be run as root!\n"
  exit 1
fi

install -m 644 hostname-derived-mac@.service /etc/systemd/system/
