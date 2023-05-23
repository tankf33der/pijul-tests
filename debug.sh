#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

pijul debug
pijul add debug.*
record

for _ in {0..50}
do
	pijul debug
	record
done
