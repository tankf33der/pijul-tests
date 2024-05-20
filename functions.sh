#!/usr/bin/env bash

beta=3
incbeta() {		# valid values from 3 to 9
    beta=$((beta + 1))
    if [ $beta = 10 ]
    then
        beta=3
    fi
}

exist() {
	local f=$1
	if [ ! -e "$f" ]; then
		exit 61
	fi
}

eq () {
	if [ "$1" -ne "$2" ]; then
		exit 62
	fi
}

eqfiles () {
	exist "$1"
	exist "$2"
	eq "$(cksum "$1" | awk '{print $1}')" "$(cksum "$2" | awk '{print $1}')"
}

crc () {
	exist "$1"
	eq "$(cksum "$1" | awk '{print $1}')" "$2"
}

str () {
	if [ "$1" != "$2" ]; then
		exit 63
	fi
}

zero () {
	if [ "$1" -ne 0 ]; then
		exit 64
	fi
}

add () {
	pijul add -r .
}

record () {
	pijul record -am"." 1> /dev/null
}
