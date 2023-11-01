#!/bin/bash
# Installs 1password CLI

# Sanity check
if command -v op; then
    echo "$0: 1Password CLI already installed." >&2
    exit 0
fi

# Yeet if not root
if [ "$(id -u)" -ne 0 ]; then
    echo "$0: Please run as root." >&2
    exit 1
fi

# Anything below here are from https://developer.1password.com/docs/cli/get-started/ except the sudo part

# APT-based system
if command -v apt; then
    curl -sS https://downloads.1password.com/linux/keys/1password.asc |
        gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
        tee /etc/apt/sources.list.d/1password.list
    mkdir -p /etc/debsig/policies/AC2D62742012EA22/
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
        tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
    mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
    curl -sS https://downloads.1password.com/linux/keys/1password.asc |
        gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    apt update && apt install 1password-cli
fi

# YUM-based system
if command -v yum; then
    rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    dnf check-update -y 1password-cli && sudo dnf install 1password-cli
fi

# Alpine
if command -v apk; then
    echo https://downloads.1password.com/linux/alpinelinux/stable/ >>/etc/apk/repositories
    wget https://downloads.1password.com/linux/keys/alpinelinux/support@1password.com-61ddfc31.rsa.pub -P /etc/apk/keys
    apk update && apk add 1password-cli
fi
