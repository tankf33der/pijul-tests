#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

cp ../../pijul-tests/liner.py .
cp ../../pijul-tests/peace-and-war.txt .

pijul add peace-and-war.txt
record

for _ in {0..128}; do
	./liner.py
	record
done

echo "OK--peace-liner"
