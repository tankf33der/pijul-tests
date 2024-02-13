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


# milestone #1
cd ..
pijul clone --path Makefile repo Makefile
cd Makefile
crc Makefile 2090994418

# milestone #1a
cd ..
pijul clone --path net/ipv4/arp.c repo arpc
cd arpc
crc net/ipv4/arp.c 2199210372

# milestone #2
cd ..
pijul clone --path net/ipv4 repo ipv4
cd ipv4
crc net/ipv4/arp.c 2199210372
cd ..
diff -qr repo/net/ipv4 ipv4/net/ipv4

echo "OK--partial-all"
