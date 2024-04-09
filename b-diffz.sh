#!/usr/bin/env bash

set -x -e

sed='sed'
python='python3'
u=$(uname)
if [ "$u" = "FreeBSD" ] || [ "$u" = "Darwin" ]; then
	sed='gsed'
elif [ "$u" = "NetBSD" ]; then
	sed='gsed'
	python='python3.12'
fi

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
pijul clone repo repo2
cp ../pijul-tests/B.txt repo2/A.txt
cp ../pijul-tests/assert.py repo2/
cd repo2

add
pijul record --patience -am.

for i in {0..255}; do
	$sed -i "0,/Z/s//${i}/" A.txt
	pijul record --patience -am.
	pijul push -a

	cd ../repo
	"$python" ./assert.py "${i}"
	cd ../repo2
done

echo "OK--b-diffz"
