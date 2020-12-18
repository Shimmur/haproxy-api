#!/bin/bash

if [[ `id -u` != "0" ]]; then
	echo "You must run this as root/sudo"
	exit 1
fi

# Handle aliasing the IP address locally
echo "Adding alias on loopback for 192.168.168.168"
if [[ `uname -s` == "Darwin" ]]; then
	ifconfig lo0 alias 192.168.168.168 255.255.255.255
else
  if [[ `uname -s` == "linux" ]] || [[ `uname -s` == "Linux" ]]; then
	ip address add 192.168.168.168/32 dev lo
  fi
fi
