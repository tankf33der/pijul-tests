#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

pijul channel new mike
tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
find kernel/ -type f -exec sh -c " pijul add "{}" && pijul rec -am"."" \;
pijul apply --channel mike $(pijul log --hash-only | shuf)
find net/ -type f -exec sh -c " pijul add "{}" && pijul rec -am"."" \;
pijul apply --channel mike $(pijul log --hash-only | shuf)
find drivers/ -type f -exec sh -c " pijul add "{}" && pijul rec -am"."" \;
pijul apply --channel mike $(pijul log --hash-only | shuf)
pijul add Makefile
record
pijul apply --channel mike $(pijul log --hash-only | shuf)

for i in {2..40}; do
	pijul fork "$i"
	pijul channel switch "$i"

	xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
    record

	H=$(pijul log --hash-only | head -1)
	pijul apply "$H" --channel main

	pijul channel switch main
done

pijul apply --channel mike $(pijul log --hash-only | shuf)

pijul channel switch 28
H=$(pijul log --hash-only | head -1)
pijul apply "$H" --channel main
pijul channel switch main
crc Makefile 2090994418

pijul channel switch mike
crc Makefile 2090994418
pijul channel switch main

echo "OK--add-viafiles"
