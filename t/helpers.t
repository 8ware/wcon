#! /usr/bin/env bash
#
# vim:ft=sh:fdm=marker
#

source default-values.sh
source helpers.sh

IFS=$'\n'

# {{{ iwlist fake
function iwlist() {
	cat <<-IWLIST
		wlan0     Scan completed :
          Cell 01 - Address: C8:D7:19:93:1E:F8
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=61/70  Signal level=-49 dBm  
                    Encryption key:on
                    ESSID:"C3D2-fallback"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=000005c7ba522461
                    Extra: Last beacon: 48ms ago
                    IE: Unknown: 000D433344322D66616C6C6261636B
                    IE: Unknown: 010882848B962430486C
                    IE: Unknown: 030101
                    IE: Unknown: 2A0106
                    IE: Unknown: 2F0106
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown: 32040C121860
                    IE: Unknown: DD090010180200F0000000
		Cell 07 - Address: 02:CA:FE:CA:CA:40
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=66/70  Signal level=-44 dBm  
                    Encryption key:off
                    ESSID:"batman-adv"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s
                    Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Ad-Hoc
                    Extra:tsf=0000001cae066b4b
                    Extra: Last beacon: 48ms ago
                    IE: Unknown: 000A6261746D616E2D616476
                    IE: Unknown: 010882040B160C121824
                    IE: Unknown: 03010B
                    IE: Unknown: 06020000
                    IE: Unknown: 32043048606C
                    IE: Unknown: 2D1AEF111BFFFF000000000000000000000100000000000000000000
                    IE: Unknown: 3D160B0700000000FFFF0000000000000000000000000000
                    IE: Unknown: DD070050F202000100
	IWLIST
}
# }}}

ssids=( $(get_ssids) )
expected=( C3D2-fallback batman-adv )
[ ${#ssids[@]} -eq ${#expected[@]} ]; TEST "get_ssids (count)"
[ "${ssids[*]}" == "${expected[*]}" ]; TEST "get_ssids (elements)"

output=$(hook non_existent "success")
[ "$output" == "success" ]; TEST "hook"

password=$(get_password "SSID" <<< "secret")
[ "$password" == "secret" ]; TEST "get_password"

