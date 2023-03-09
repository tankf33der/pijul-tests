#!/usr/bin/env bash
set -x -e

source ./functions.sh

cd ..
rm -rf pijul-tests-data
mkdir pijul-tests-data
cd pijul-tests-data
pijul init repo
cd repo

cp ../../pijul-tests/utf8.txt .
cp ../../pijul-tests/utf8-sum.py .
cp ../../pijul-tests/utf8-shuffle.py .

# ready!
./utf8-sum.py utf8.txt
add
pijul record --patience -am"."

for _ in {0..256}; do
	./utf8-shuffle.py utf8.txt
	mv utf8-2.txt utf8.txt
	pijul record --patience -am"."
done

# clone
cd ..
pijul clone repo repo2
cd repo2
./utf8-sum.py utf8.txt

echo "OK--patience"
