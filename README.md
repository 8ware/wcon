wcon - A modular WiFi connector using wpa_supplicant
====================================================

Installation
------------

	$ git clone https://github.com/8ware/wcon.git
	$ cd wcon
	$ ln -s "$PWD/bin/wcon" ~/bin/wcon

Configuration
-------------

The idea is to simply add a configuration for a new WiFi network instead of
blowing up one big configuration file. Thus for each SSID a configuration file
in the `wpa_supplicant` format (WPA_SUPPLICANT.CONF(5)) must be provided. The
configuration is then choosen by the SSID using the `$WCON_CONFIGS` variable
which is required to be declared as associative array whose keys are the SSIDs
and its values the config files. The function `load_configs "${paths[@]}"` can
be used to fulfill that requirement. In fact, that function assumes that the
config files are named according to a `<SSID>.conf` schema. For example, the
SSID `Home` will be represented by the config file `Home.conf`. For handling
more complex SSIDs, i.e. SSIDs with non-alphanumeric characters, see function
`hook_beautify` in section _Example Configuration_ below. To avoid adding the
common config to each file (e.g. `ctrl_interface=/var/run/wpa_supplicant`) a
dedicated hook which prints the commonalities can be specified (see function
`hook_common_config` below).

To avoid storing passwords in plain text within the configuration files the
`hook_password` can be specified which expects the SSID and delivers the
password for it.

### Example Configuration

	$ ls ${XDG_CONFIG_HOME:-~/.config}/wcon
	common.conf     HomeSSID.conf     rc.sh     WorkSSID.conf

	$ cat ${XDG_CONFIG_HOME:-~/.config}/wcon/rc.sh

	CONFIG_HOME=$(dirname "$(readlink -f "$BASH_SOURCE")")

	load_configs "$CONFIG_HOME"/*.conf
	function hook_comon_config() {
		cat "$CONFIG_HOME/common.conf"
	}

	function hook_beautify_ssid() {
		echo ${1//[^[:alnum:]]}
	}

	# use password-store (http://www.passwordstore.org)
	function hook_password() {
		pass "wifi/$1"
	}

	WCON_VERBOSITY=1 # can be set to any level, e.g. 5

Usage
-----

Since in one location often a particular WiFi is used the SSID can be selected
automatically by determining which available SSID is already configured. Thus
the following command is sufficient to connect to the WiFi:

	$ wcon

Further arguments are not recognized by now.

