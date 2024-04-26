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
add
record

cd ..
pijul clone repo repo2
cd repo2

# milestone #1: stairs UP
for i in {1..8192}; do
	dd if=/dev/random of=a seek=0 count=1 bs="$i" conv=notrunc
	record
done

# milestone #2: stairs DOWN
for i in {8192..1}; do
	dd if=/dev/random of=a seek=0 count=1 bs="$i"
	record
done

pijul push -a
cd ../repo
eq 1 "$(cksum a | awk '{print $2}')"
cd ..
pijul clone repo repo3

echo "OK--diff"
