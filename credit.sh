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
pijul add a
record
for _ in {0..15}; do
	date +%s-%N >> a
    record
done
eq 17 "$(pijul credit a | grep -c "^[A-Z0-9]")"

echo "OK--credit"
