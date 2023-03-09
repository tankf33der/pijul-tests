#!/usr/bin/env bash

set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cp ../pijul-tests/A.txt repo/
cp ../pijul-tests/assert.py repo/
cd repo

add
pijul record --patience -am"."

for i in {0..64}; do
	sed -i "0,/Z/s//${i}/" A.txt
	pijul record --patience -am"."

	cd ..
	pijul clone repo repo2
	cd repo2
	python3 assert.py ${i}
	cd ..
	rm -rf repo2
	cd repo

done

echo "OK--A"
