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
# all hashes, uniq, randomly sorted
# for H in $(pijul credit Makefile | grep -iPo "^\w+(, \w+)*$"  | tr -d ' ' | awk -F, '{for(i=1;i<=NF;i++) { print substr($i, 1, length($i)-1)}}' | sort -u); do
for H in $(pijul credit Makefile | grep -o "^[[:alnum:]]*" | sort -u | shuf); do
	pijul apply --channel mike1 "$H"
done

pijul channel switch mike1
eq 2090994418 "$(cksum Makefile | awk '{print $1}')"
pijul channel switch main

cd ..
pijul clone --channel mike1 repo repo2
zero "$(diff -qr repo repo2 | grep -cv ".pijul")"

# XXX, second test
cd repo
i=1
for H in $(pijul log --hash-only); do
	pijul channel new "$i"
	pijul apply "$H" --channel "$i"
	i=$((i+1))
done

pijul channel switch 1
eq 2090994418 "$(cksum Makefile | awk '{print $1}')"
pijul channel switch main

for i in {1..40}; do
    pijul channel delete "$i"
done

echo "OK--apply-tonew"
