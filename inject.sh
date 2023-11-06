#!/bin/bash
# Injects homelab repository and executes $@ as command

HOMELAB_REPOSITORY="https://github.com/selubi/homelab"
HOMELAB_DIRECTORY="/etc/homelab"

# Install git
if ! command -v git &>/dev/null; then
    command -v apt &>/dev/null && apt install git
    command -v yum &>/dev/null && yum install git
fi

# Clean clone homelab repository
rm -r "$HOMELAB_DIRECTORY"
git clone "$HOMELAB_REPOSITORY" "$HOMELAB_DIRECTORY"

# Execute commands passed by args
cd "$HOMELAB_DIRECTORY" || exit 1
"$@"
