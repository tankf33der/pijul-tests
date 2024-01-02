#!/usr/bin/env bash

set -x -e

sed='patch'
u=$(uname)
if [ "$u" = "FreeBSD" ]; then
	sed='gpatch'
fi

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
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   add
   record
done

eq 2484 "$(pijul ls | wc -l)"

H="$(pijul log --hash-only | head -1)"
pijul fork Reset2040
pijul apply "$H" --channel Reset2040
pijul channel switch Reset2040
for i in {0..38}; do
	H="$(pijul log --hash-only | head -1)"
	pijul unrecord "$H" --reset
done

pijul channel switch main
for i in {0..38}; do
	H="$(pijul log --hash-only | head -1)"
	pijul unrecord "$H"
done

eq 2529 "$(pijul ls | wc -l)"
eq 2 "$(pijul log --hash-only | wc -l)"

pijul reset
eq 2143 "$(pijul ls | wc -l)"
pijul channel switch Reset2040
zero "$(pijul diff --channel main | wc -l)"

echo "OK--rec-un-rec"
