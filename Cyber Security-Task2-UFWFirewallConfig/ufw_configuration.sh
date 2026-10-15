#!/bin/bash

# UFW Firewall Configuration Script
sudo apt install ufw
sudo ufw enable
sudo ufw allow ssh        # Allow port 22
sudo ufw deny http        # Deny port 80
sudo ufw allow https      # Additional rule 1
sudo ufw deny 23          # Additional rule 2 (Deny telnet)
sudo ufw status verbose
