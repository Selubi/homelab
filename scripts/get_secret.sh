#!/bin/bash

function usage() {
    echo "$0 <reference>
    Gets secret from 1password.
    Expects OP_SERVICE_ACCOUNT_TOKEN environment variable to be set.
    More info on reference: https://developer.1password.com/docs/cli/reference/commands/read/".
}

# Installs 1password CLI if its yet installed
command -v op || scripts/install_1password.sh

# Only accept one argument
if [ $# -ne 1 ]; then
    usage
    exit 1
fi

# Get the secret
op read "$1"

