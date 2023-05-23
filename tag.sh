#!/usr/bin/env bash

set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

touch a
echo "0" >> a
pijul add a
record
pijul tag create -m"."

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record
pijul tag create -m"."
for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   add
   record
   pijul tag create -m.

   T="$(pijul tag | head -1 | awk '{print $2}')"
   L="$(pijul log --state | head -4 | tail -1 | awk '{print $2}')"
   str "$T" "$L"
done

exit 0

FIRST="$(pijul tag  | grep State | tail -1 | awk '{print $2}')"
LAST="$(pijul tag  | grep State | head -1 | awk '{print $2}')"
pijul tag checkout "$FIRST"
pijul tag checkout "$LAST"
# FIRST
pijul channel switch  "$FIRST"
eq 4200087900 "$(cksum a | awk '{print $1}')"
eq 1 "$(pijul ls | wc -l)"
# LAST
pijul chann switch main
pijul channel switch  "$LAST"
eq 2090994418 "$(cksum Makefile | awk '{print $1}')"
eq 4200087900 "$(cksum a | awk '{print $1}')"

echo "OK--tag"
