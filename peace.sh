#!/usr/bin/env bash

set -x -e

source ./functions.sh

T=$(date +%s)

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cp ../pijul-tests/peace-and-war.txt repo/peace.txt
cd repo
add
record

for _ in {0..256}; do
   shuf peace.txt -o peace.txt
   pijul record --timestamp "$T" -am"." 1> /dev/null
done

cd ..
pijul clone repo repo2
eq 2 "$(diff -qr repo repo2 | wc -l)"

echo "OK--peace"
