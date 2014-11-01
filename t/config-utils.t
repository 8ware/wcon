#! /usr/bin/env bash
#
# vim:ft=sh
#

source config-utils.sh

IFS=$'\n'

declare -A expected=( [test]=test.conf [example]=example.conf )
load_configs "${expected[@]}"
[ "${!WCON_CONFIGS[*]}" == "${!expected[*]}" ]; TEST "load_configs (ssids)"
[ "${WCON_CONFIGS[*]}" == "${expected[*]}" ]; TEST "load_configs (configs)"

