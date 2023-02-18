#!/usr/bin/env bash

set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cp ../pijul-tests/A.txt repo/
cd repo

add
record

for i in {0..64}; do
	sed -i "0,/Z/s//${i}/" A.txt
	record
done

cd ..
pijul clone repo repo2
eq 2 "$(diff -qr repo repo2 | wc -l)"

echo "OK--A"
