#!/usr/bin/env bash
set -x -e

source ./../functions.sh

cd ../..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
pijul clone repo repo2
cd repo

tar -xJf ../../pijul-tests/kernel/linux-2.0.1.tar.xz --strip-components=1
add
record

for i in {2..40}; do
	xzcat ../../pijul-tests/patches/patch-2.0."$i".xz | patch -sp1
	add
	record

	cd ../repo2
	pijul pull --path net -a
	cd ..
	zero "$(diff -qr repo/net repo2/net | wc -l)"
	cd repo
done

echo "OK--partial-pull"
