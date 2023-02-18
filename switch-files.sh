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
echo "1" >> a
record
echo "1" >> a
record
echo "1" >> a
record
eq 0 "$(pijul diff --short | wc -l)"

pijul fork m1
pijul channel switch m1
touch b
mkdir -p c/d
add
record
echo "1" >> b
record
eq 0 "$(pijul diff --short | wc -l)"
eq 4 "$(ls -l | wc -l)"
eq 5 "$(pijul ls | wc -l)"

pijul channel switch main
eq 4 "$(ls -l | wc -l)"
eq 1 "$(pijul ls | wc -l)"

echo "OK--switch-files"
