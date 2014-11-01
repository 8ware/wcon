#! /usr/bin/env bash
#
# Sourcing this script will restore the user's environment variables $USER and
# $HOME to its original values iff the script is called with sudo.
#

if [ "$SUDO_USER" ]; then
	USER="$SUDO_USER"
	HOME=$(eval "echo ~$USER")
fi

