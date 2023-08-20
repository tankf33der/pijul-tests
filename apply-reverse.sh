#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo
pijul fork Reverse

tar -xJf ../../pijul-tests/kernel/linux-2.0.40.tar.xz -C "../"

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -Esp1
   add
   record
done

for i in {40..1}; do
	H=$(pijul log --hash-only | head -"$i" | tail -1)
	pijul apply "$H" --channel Reverse
done

pijul channel switch Reverse
eq 0 "$(diff -qr ../linux-2.0.40 . | grep -cv "Only in")"

rm -rf ../linux-2.0.40

echo "OK--apply-reverse"
