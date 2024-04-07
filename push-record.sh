#!/usr/bin/env bash
set -x -e

tac='tac'
u=$(uname)
if [ "$u" = "FreeBSD" ]; then
        tac='gtac'
fi

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
pijul clone repo repo2
cd repo2

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..40}; do
   xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -Esp1
   add
   record
done

for H in $(pijul log --hash-only | $tac); do
	pijul push ../repo -- "$H"
done

cd ../repo
crc Makefile 2090994418

echo "OK--push-record"
