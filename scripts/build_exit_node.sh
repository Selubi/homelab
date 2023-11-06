#!/bin/bash
# Builds tailscale exit node
# Supported OS: Ubuntu Jammy

# Yeet if not root
if [ "$(id -u)" -ne 0 ]; then echo "$0: Please run as root." >&2; exit 1; fi

# Every step is important
set -e

# Get tailscale auth key
TAILSCALE_AUTH_KEY=$(scripts/get_secret.sh op://secrets/TAILSCALE_AUTH_KEY/credential)

# Add Tailscale’s package signing key and repository
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# Install Tailscale
apt-get update
apt-get -y install tailscale

# Enable IP formwarding
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

# Start tailscale
tailscale up --ssh --advertise-exit-node --authkey "$TAILSCALE_AUTH_KEY"
echo "Don't forget to allow the exit node from the admin console"
