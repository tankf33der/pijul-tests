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
eq 2143 "$(pijul ls | wc -l)"

for i in {2..40}; do
	H=$(pijul log --hash-only | head -1)
	pijul fork "$i"
	pijul apply "$H" --channel "$i"
	pijul channel switch "$i"

	xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
	add
	record
done

H=$(pijul log --hash-only | head -1)
pijul apply "$H" --channel main
pijul channel switch main
MAKE=$(cksum Makefile | awk '{print $1}')
eq 2090994418 "$MAKE"

echo "OK--fork-train"
