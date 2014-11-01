#! /usr/bin/env bash

# network interface (wlan0) and driver (wext)
WCON_INTF=${WCON_INTF:-wlan0}
WCON_DRIVER=${WCON_DRIVER:-wext}

# hook prefix
WCON_HOOK_PREFIX=${WCON_HOOK_PREFIX:-hook}

# placeholder for passwords in config files
WCON_PW_PLACEHOLDER=${WCON_PW_PLACEHOLDER:-%PASSWORD%}

# verbosity level
WCON_VERBOSITY=${WCON_VERBOSITY:-0}

# action script TEMPlate
WCON_ACTION_PREFIX=${WCON_ACTION_PREFIX:-wcon-action}
WCON_ACTION_TEMPLATE="$WCON_ACTION_PREFIX.XXXXXXX.sh"

