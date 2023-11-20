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
touch b
pijul add b
record
touch c
pijul add c
record
touch d
pijul add d
record

echo "1" >> a
echo "1" >> b
record

echo "2" >> b
echo "2" >> c
record

echo "3" >> c
echo "2" >> d
record

echo "4" >> b
echo "4" >> c
record

echo "5" >> a
echo "5" >> c
record

pijul channel new m1
H=$(pijul log --hash-only | head -1)
pijul apply "$H" --channel m1
pijul channel switch m1
crc a 1781451400
crc b 930277684
crc c 2376366260
crc d 4192802898

echo "OK--braid"
