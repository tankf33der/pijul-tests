#!/usr/bin/env bash
# https://nest.pijul.com/pijul/pijul/discussions/327
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
eq 1 "$(pijul ls | wc -l)"
eq 0 "$(pijul diff --short | wc -l)"

pijul remove a
record
rm a
mkdir a
pijul add a
record

H="$(pijul log --hash-only | head -2 | tail -1)"
pijul unrecord "$H"
eq 1 "$(pijul diff --short | wc -l)"
record
eq 1  "$(pijul ls | wc -l)"

echo "OK--doubleitems"
