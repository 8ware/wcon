#! /usr/bin/env bash

function verbose() {
	local level=$1
	local message=$2

	if [ -t 1 -a $level -le $WCON_VERBOSITY ]; then
		echo "$(basename "$0"): $message"
	fi
}

function hook() {
	local hook_name=$1
	shift

	local hook="${WCON_HOOK_PREFIX}_$hook_name"
	if declare -F $hook > /dev/null; then
		$hook "$@"
		return 0
	else
		# return false if no default value was given
		[ $# -gt 0 ] && echo "$@"
		return 1
	fi
}

function get_password() {
	local ssid=$1

	local password
	if ! password=$(hook password "$ssid"); then
		read -r -p "Enter password for $ssid: " -s password
		[ -t 0 ] && echo >&2
	fi

	if [ "$password" ]; then
		echo $password
	else
		return 1
	fi
}

function get_ssids() {
	local IFS=$'\n' ssid regex='(?<=ESSID:")[^"]+'
	for ssid in $(iwlist "$WCON_INTF" scan 2>/dev/null | grep -oP "$regex"); do
		ssid=$(hook beautify "$ssid")
		echo "$ssid"
	done

	[ ${#ssids[@]} -gt 0 ]
}

function next_config() {
	local ssid=$1

	local config=${WCON_CONFIGS[$ssid]}
	if [ "$config" ]; then
		echo "$config"
		return 0
	fi

	return 1
}

function prepare_config() {
	local ssid=$1
	local config=$2

	hook common_config

	if grep -q "$WCON_PW_PLACEHOLDER" "$config"; then
		local password=$(get_password "$ssid")
		perl -pe "\$pw=$password; s/\Q$WCON_PW_PLACEHOLDER\E/\$pw/" "$config"
	else
		cat "$config"
	fi
}

function action() {
	local action_file=$(mktemp --tmpdir "$WCON_ACTION_TEMPLATE")
	chmod 755 "$action_file"
	cat <<-ACTION > "$action_file"
		#! /usr/bin/env bash

		function notify() {
		 	sudo -u "$USER" DISPLAY=$DISPLAY notify-send "WCON" "\$*"
		}

		if [ "\$2" == "CONNECTED" ]; then
		 	dhclient "\$1"
		 	notify "CONNECTED to $WCON_INTF"
		elif [ "\$2" == "DISCONNECTED" ] && pidof dhclient > /dev/null; then
		 	notify "DISCONNECTED from $WCON_INTF"
		 	pkill dhclient
		#	rm -f "\$0"
		#	sudo pkill wpa_cli
		fi

	ACTION

	echo "$action_file"
}

function kill_if_running() {
	local what=$1

	if pidof "$what" > /dev/null; then
		pkill "$what"
		verbose 3 "killed $what"
	fi
}

function get_user_config() {
	local configs=(
		"$WCON_CONFIG"
		"./.wconrc"
		"$HOME/.wconrc"
		"$HOME/.wcon/rc.sh"
		"${XDG_CONFIG_HOME:-$HOME/.config}/wconrc"
		"${XDG_CONFIG_HOME:-$HOME/.config}/wcon/rc.sh"
	)

	local config
	for config in "${configs[@]}"; do
		if [ -f "$config" -a -r "$config" ]; then
			echo "$config"
			return 0
		fi
	done

	return 1
}

