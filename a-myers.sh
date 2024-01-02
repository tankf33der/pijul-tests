#!/usr/bin/env bash

set -x -e

sed='sed'
u=$(uname)
if [ "$u" = "FreeBSD" ]; then
	sed='gsed'
fi

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
record

for i in {0..64}; do
	$sed -i "0,/Z/s//${i}/" A.txt
	record

	cd ..
	pijul clone repo repo2
	cd repo2
	./assert.py "${i}"
	cd ..
	rm -rf repo2
	cd repo

done

echo "OK--a-myers"
