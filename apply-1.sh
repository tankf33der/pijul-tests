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
for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   add
   record
done

pijul channel new mike1
for H in $(pijul credit Makefile | grep -o "^[[:alnum:]]*" | sort -u | head -2); do
	pijul apply --channel mike1 "$H"
done

i=1
for H in $(pijul log --hash-only | head -9); do
	pijul channel new "$i"
	pijul apply "$H" --channel "$i"
	i=$((i+1))
done

echo "OK--apply-1"
