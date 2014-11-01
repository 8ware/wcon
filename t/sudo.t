#! /usr/bin/env bash
#
# vim:ft=sh
#

EXPECTED_USER=$USER
EXPECTED_HOME=$HOME

SUDO_USER=$USER
USER=root
HOME=/root

source sudo.sh

[ "$USER" == "$EXPECTED_USER" ]; TEST "\$USER"
[ "$HOME" == "$EXPECTED_HOME" ]; TEST "\$HOME"

