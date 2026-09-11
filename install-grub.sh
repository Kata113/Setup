#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root:"
    echo "sudo $0"
    exit 1
fi

if [[ ! -d /sys/firmware/efi ]]; then
    echo "ERROR: System is not booted in UEFI mode."
    exit 1
fi

if ! mountpoint -q /boot/efi; then
    echo "ERROR: /boot/efi is not mounted."
    echo
    echo "Check with:"
    echo "findmnt /boot/efi"
    exit 1
fi

echo "=== Installing GRUB ==="

grub-install \
    --target=x86_64-efi \
    --efi-directory=/boot/efi \
    --bootloader-id=CachyOS

echo
echo "=== Generating GRUB configuration ==="

grub-mkconfig -o /boot/grub/grub.cfg

echo
echo "================================"
echo " GRUB installation completed!"
echo "================================"