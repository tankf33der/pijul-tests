#!/usr/bin/env bash

eq () {
	if [ "$1" -ne "$2" ]; then
		exit 63
	fi
}

eqfiles () {
	eq "$(cksum $1 | awk '{print $1}')" "$(cksum $2 | awk '{print $1}')"
}

crc () {
	eq "$(cksum $1 | awk '{print $1}')" "$2"
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
