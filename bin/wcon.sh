#! /usr/bin/env bash

# This is required if the script is simply symlinked to the user's bin
# directory.
if [ ! "$SUDO_USER" ]; then
	echo "Need root privileges. Restarting script with sudo..." >&2
	sudo "$0"
	exit
fi

WCON=$(readlink -f "$0")
WCON_HOME="$(dirname "$WCON")/.."
PATH="$WCON_HOME/lib:$WCON_HOME/etc:$PATH"

source config-utils.sh
source helpers.sh
source sudo.sh

# source configuration script
source "$(get_user_config)" || {
	echo "User config not found." >&2
	exit 1
}

source default-values.sh


kill_if_running wpa_supplicant
kill_if_running wpa_cli
kill_if_running dhclient
rm -f "${TMPDIR:-/tmp}/$WCON_ACTION_PREFIX"*

if [ "$1" == --restart ]; then
	exit
fi


verbose 3 "bringing $WCON_INTF up..."
ifconfig "$WCON_INTF" up

verbose 1 "searching for configs..."
for ssid in $(get_ssids); do
	config=$(next_config "$ssid") && break
done
[ "$config" ] || {
	echo "No config found." >&2
	exit 1
}


if [ -t 1 ]; then
	verbose 1 "chosen SSID: $ssid"
	verbose 1 "chosen config: $(dirname "$config")"
	verbose 5 "full path: ${config/#$HOME/\~}"

	verbose 1 "starting wpa_supplicant..."
#	prepare_config "$ssid" "$config"
	wpa_supplicant -c <(prepare_config "$ssid" "$config") \
			-i "$WCON_INTF" -D "$WCON_DRIVER" -W -B &>/dev/null

	verbose 1 "starting wpa_cli..."
	wpa_cli -i "$WCON_INTF" -a "$(action)" &> /dev/null &
else
	prepare_config "$ssid" "$config"
fi

