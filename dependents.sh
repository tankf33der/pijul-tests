#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

pijul channel new Empty

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record
eq 2143 "$(pijul ls | wc -l)"

for i in {2..3}; do
	xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
	add
	record
done

H=$(pijul log --hash-only | head -1)
eq 3 "$(pijul dependents "$H" | wc -l)"
# for H in $(pijul dependents "$H"); do
	# pijul apply --channel Empty "$H"
	# assert always two channels
# done
#
# M=$(cksum Makefile | awk '{print $1}')
# pijul channel switch Empty
# eq "$M" "$(cksum Makefile | awk '{print $1}')"

echo "OK--dependents"
