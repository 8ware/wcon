#! /usr/bin/env bash

function load_configs() {
	declare -Ag WCON_CONFIGS

	local config ssid
	for config in "$@"; do
		ssid=$(basename "${config%.conf}")
		WCON_CONFIGS[$ssid]=$config
	done
}

