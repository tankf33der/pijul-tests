#!/usr/bin/env bash

eq () {
	if [ "$1" -ne "$2" ]; then
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
