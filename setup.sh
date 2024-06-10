#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Install necessary packages
apt-get update
apt-get install -y dnsmasq iptables

# Download and setup hostapd-mana
echo "Downloading hostapd-mana..."
wget https://github.com/sensepost/hostapd-mana/releases/download/v2.6/hostapd-mana-2.6.tgz
tar xvf hostapd-mana-2.6.tgz
cd hostapd-mana-2.6/hostapd
make
export PATH="$PATH:$(pwd)"
cd ../..

# Download berate_ap
echo "Downloading berate_ap..."
git clone https://github.com/sensepost/berate_ap
cd berate_ap
chmod +x berate_ap

echo "Setup complete. You can now run berate_ap using './berate_ap'."
