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
pijul tag create -m.

for _ in {0..1}
do
	pijul debug
	record
	pijul tag create -m.
done

pijul rm debug.*
record
pijul tag create -m.


pijul debug
pijul add debug.*
record
pijul tag create -m.
