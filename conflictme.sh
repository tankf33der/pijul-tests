#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..3}; do
	# in the main
	pijul channel new "$i"
	pijul channel switch "$i"
	tar -xJf ../../pijul-tests/kernel/linux-2.0."$i".tar.xz --strip-components=1
	add
	record
	H=$(pijul log --hash-only | head -1)
	pijul apply "$H" --channel main

	pijul channel switch main
	for C in $(find . -maxdepth 1 | egrep ".[A-Z0-9]{13}+$" | cut -c 3-); do
		N=${C%.*}
		pijul remove "$C"
		rm -rf "$N"
		mv "$C" "$N"
		pijul add -r "$N"
	done
	record

	zero $(pijul ls | egrep ".[A-Z0-9]{13}+$" | wc -l)

	pijul channel switch "$i"
	# pijul channel switch main
done

# pijul channel new 2040
# pijul channel switch 2040
# tar -xJf ../../pijul-tests/kernel/linux-2.0.3.tar.xz --strip-components=1
# pijul channel switch main


# eq 2090994418 "$(cksum Makefile | awk '{print $1}')"

echo "OK--conflictme"
