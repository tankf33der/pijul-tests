#!/usr/bin/env bash
# https://nest.pijul.com/pijul/pijul/discussions/292
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
pijul fork m1
eq 1 "$(pijul diff -su | wc -l)"
pijul channel switch m1
eq 1 "$(pijul diff -su | wc -l)"

rm -rf a
mkdir a
record
eq 1 "$(pijul diff -su | wc -l)"

pijul channel switch main || exit 0

echo "OK--file2dir"
