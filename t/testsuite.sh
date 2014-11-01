#! /usr/bin/env bash
#
# TODO generate TAP output, see
#      https://github.com/ingydotnet/test-tap-bash
#      https://github.com/illusori/bash-tap
#

BASE="$(dirname "$0")/.."
PATH="$BASE/lib:$BASE/etc:$PATH"


PASSED=()
FAILED=()

function TEST() {
	if [ $? -eq 0 ]; then
		echo "> ok : $1"
		PASSED+=( "$1" )
	else
		echo "> failed : $1"
		FAILED+=( "$1" )
	fi
}


function prepare_testcase() {
	STATE=STATE$'\n'
	STATE+=$(declare -p | grep -oP '^declare.+?\K\w+(?==)')
}

function cleanup_testcase() {
	for var in $(declare -p | grep -oP '^declare.+?\K\w+(?==)'); do
		if ! grep -q "^$var$" <<< "$STATE"; then
			unset "$var"
		fi
	done
}


testcases=( "$@" )
if [ ${#testcases[@]} -eq 0 ]; then
	testcases=( "$(dirname "$0")"/*.t )
fi

for testcase in "${testcases[@]}"; do
	prepare_testcase
	echo "testcase '$(basename "$testcase")':"
	source "$testcase"
	cleanup_testcase
done

echo "---"
echo "total: passed=${#PASSED[@]} failed=${#FAILED[@]}"

# exit status
[ ${#FAILED[@]} -eq 0 ]

