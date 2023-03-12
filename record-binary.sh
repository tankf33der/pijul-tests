#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

for _ in {0..16}; do
	pijul archive -o mike
	pijul add -rf .pijul mike.tar.gz
	pijul record -am"."

	cd ..
	pijul clone repo repo2
	cd repo2
	gzip -t mike.tar.gz
	cd ..
	rm -rf repo2
	cd repo
done

echo "OK--record-binary"
