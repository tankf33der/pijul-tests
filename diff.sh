#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo
cp ../../pijul-tests/diff.txt .
cp ../../pijul-tests/diff.dat .
add
record

# milestone #1 - text file
for i in {0..1054}; do
	echo -ne '.' | dd of=diff.txt bs=1 seek="$i" count=1 conv=notrunc
	eq 1 "$(pijul diff -s | wc -l)"
	eq 1 "$(pijul diff -s --patience | wc -l)"
	pijul reset --force
done

# milestone #2 -
for i in {0..1023}; do
	echo -ne '\xdd' | dd of=diff.dat bs=1 seek="$i" count=1 conv=notrunc
	eq 1 "$(pijul diff -s | wc -l)"
	eq 1 "$(pijul diff -s --patience | wc -l)"
	pijul reset --force
done

echo "OK--diff"
