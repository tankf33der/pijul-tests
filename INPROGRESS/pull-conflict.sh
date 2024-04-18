#!/usr/bin/env bash
# https://nest.pijul.com/pijul/pijul/discussions/416
set -x -e

source ./../functions.sh

cd ../..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init p1
pijul clone p1 p2

# set
cd p1
touch a
pijul add a
record

cd ../p2
touch a
pijul add a
record

# create conflict
pijul pull -a

# assert 1
H="$(pijul diff | grep "1. Moved" | awk '{split($4,a,"."); print substr(a[2],1, length(a[2])-1)}')"
eq 1 "$(pijul log --hash-only | grep -c "$H")"

# assert 2
L="$(pijul diff | tail -2 | head -1)"
eq 1 "$(echo "$L" | grep -c "BFD")"
eq 4 "$(echo "$L" | grep -o BF | wc -l)"

echo "OK--pull-conflict"
