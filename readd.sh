#!/usr/bin/env bash
# https://nest.pijul.com/pijul/pijul/discussions/322
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

pijul fork m1
pijul chann switch m1
mkdir b
touch a b/1 b/2
add
record
eq 0 "$(pijul diff --short | wc -l)"
eq 5 "$(pijul ls | wc -l)"

H="$(pijul log --hash-only | head -1)"
pijul apply "$H" --channel main
pijul channel switch main
eq 5 "$(pijul ls | wc -l)"

pijul remove b
record
H="$(pijul log --hash-only | head -1)"
pijul apply "$H" --channel m1
pijul channel switch m1
eq 2 "$(pijul ls | wc -l)"

pijul add -r b
echo "1"
eq 3 "$(pijul diff --short | wc -l)"
record
eq 5 "$(pijul ls | wc -l)"
eq 0 "$(pijul diff --short | wc -l)"
pijul channel switch main
eq 2 "$(pijul ls | wc -l)"
eq 0 "$(pijul diff --short | wc -l)"

echo "OK--readd"
