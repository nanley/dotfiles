#! /run/current-system/sw/bin/bash

# Reuse some logic from system.autoUpgrade.allowReboot
booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"
if [ "$booted" != "$built" ]; then
	string='PLEASE REBOOT TO COMPLETE A SYSTEM UPDATE'
	echo " <fc=#FF0000>*** ${string} ***</fc> "
else
	echo " "
fi
