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
pijul fork Makefile
eq 2143 "$(pijul ls | wc -l)"

for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
   add
   record
   # XXX, workaround
   pijul diff Makefile --channel Makefile > mike.patch
   cat mike.patch | pijul apply --channel Makefile
   rm mike.patch
done

zero "$(pijul diff --short | wc -l)"

MAIN="$(cksum Makefile | awk '{print $1}')"
pijul channel switch Makefile
MAKE="$(cksum Makefile | awk '{print $1}')"
pijul reset
eq "$MAIN" "$MAKE"

pijul channel new Orig2040
pijul channel switch Orig2040
tar -xJf ../../pijul-tests/kernel/linux-2.0.40.tar.xz --strip-components=1
add
record
MAKE="$(cksum Makefile | awk '{print $1}')"
eq "$MAIN" "$MAKE"

pijul channel switch main
pijul channel delete Orig2040
pijul channel delete Makefile

echo "OK--fork-apply"
