#!/bin/bash

show_help() {
  echo "Usage: $0 [options] <hostname>"
  echo "Initialize VM with system updates and hostname configuration"
  echo ""
  echo "Arguments:"
  echo "  hostname           The hostname to set for this VM"
  echo ""
  echo "Options:"
  echo "  --hostname HOST    Set hostname to HOST"
  echo "  --no-update        Skip package updates"
  echo "  --no-machine-id    Skip machine ID reset"
  echo "  --no-journal       Skip journal cleanup"
  echo "  --no-history       Skip shell history cleanup"
  echo "  --no-reboot        Don't reboot after initialization"
  echo "  --no-self-delete   Don't delete this script"
  echo "  -h, --help         Show this help message"
  exit 0
}

do_update=true
do_machine_id=true
do_journal=true
clear_history=true
reboot_after=true
self_delete=true

while [[ $# -gt 0 ]]; do
  case "$1" in
  -h | --help)
    show_help
    ;;
  --hostname)
    if [[ -z "$2" ]]; then
      echo "Error: --hostname requires a value" >&2
      exit 1
    fi
    hostname="$2"
    shift 2
    ;;
  --no-update)
    do_update=false
    shift
    ;;
  --no-machine-id)
    do_machine_id=false
    shift
    ;;
  --no-journal)
    do_journal=false
    shift
    ;;
  --no-history)
    clear_history=false
    shift
    ;;
  --no-reboot)
    reboot_after=false
    shift
    ;;
  --no-self-delete)
    self_delete=false
    shift
    ;;
  -*)
    echo "Error: Unknown option $1" >&2
    exit 1
    ;;
  *)
    if [[ -n "$hostname" ]]; then
      echo "Error: Too many arguments" >&2
      exit 1
    fi
    hostname="$1"
    shift
    ;;
  esac
done

if [[ -z "$hostname" ]]; then
  echo "Error: Hostname required" >&2
  show_help
fi

[[ "$do_update" == true ]] && pacman -Syyu --noconfirm

echo "$hostname" >/etc/hostname

if [[ "$do_machine_id" == true ]]; then
  rm -f /etc/machine-id
  systemd-machine-id-setup
fi

[[ "$do_journal" == true ]] && journalctl --vacuum-time=1s

if [[ "$clear_history" == true ]]; then
  rm -f /root/.bash_history /root/.zsh_history
  find /home -name ".*_history" -delete 2>/dev/null
fi

[[ "$self_delete" == true ]] && rm -- "$0"
[[ "$reboot_after" == true ]] && reboot
