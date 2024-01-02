#!/usr/bin/env bash

set -x -e

shuf='shuf peace.txt -o peace.txt'
u=$(uname)
if [ "$u" = "FreeBSD" ]; then
	shuf='cat peace.txt | shuf -o peace2.txt | mv peace2.txt peace.txt'
fi

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

for _ in {0..128}; do
   # shuf peace.txt -o peace.txt
   $shuf
   pijul record --timestamp "$T" -am"." 1> /dev/null
done

cd ..
pijul clone repo repo2
eq 2 "$(diff -qr repo repo2 | wc -l)"

echo "OK--peace"
